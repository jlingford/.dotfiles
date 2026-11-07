#!/usr/bin/env python3
"""
Colour homologous protein chains consistently across all open ChimeraX models

Input:
    - Atomic structures open in a UCSF ChimeraX (v1.12) session
Output:
    - Protein chains coloured by homology group; chains with no homologue in any
      open model get a single fallback colour
    - "Homolog Colours" side panel to edit group colours / thresholds live
    - `homcol` command to re-run with options or export a reproducible .cxc
Purpose:
    - Structural comparison of many multi-subunit models where e.g. #1/A is
      homologous to #5/F: homologous chains get the same colour automatically.

Usage (ChimeraX command line):
    open /path/to/homolog_cols.py          # analyse all models, colour, open panel
    homcol                                 # re-run (same scope / settings)
    homcol #1-4 evalue 1e-10 coverage 0.6  # restrict scope, change thresholds
    homcol all palette okabe-ito fallback lightgray
    homcol export ~/figs/homolog_colours.cxc
    homcol reset true                      # drop manual colours, back to palette

Method:
    1. Protein chains collected per model (chain.characters = full sequence,
       including unresolved residues).
    2. Identical sequences collapsed (they are trivially in the same group).
    3. All-vs-all local alignment of unique sequences: Smith-Waterman, BLOSUM62,
       gap open 11 / extend 1, vectorised in numpy (one query vs a concatenated
       strip of all remaining targets per pass).
    4. Karlin-Altschul E-value (lambda=0.267, K=0.041; BLAST BLOSUM62 11/1).
       Traceback (identity, coverage) only for pairs passing the E-value.
    5. Pairs passing evalue / coverage / identity -> edges -> connected
       components (single linkage) = homology groups.
    6. Groups ordered by first appearance -> palette; singletons -> fallback.

WARNING:
    - Single linkage: a multidomain chain sharing one domain with two otherwise
      unrelated families will bridge them into one group. Coverage is required
      on BOTH chains, so raise `coverage` to split such bridges.
    - E-values are per pair (no correction for the number of comparisons).
    - Sequence-only: very remote homologues (<~20% identity) may be missed.
"""

# TODO:
# - [ ] Optional structure-based edges (e.g. TM-score) for remote homologues
# - [ ] Move a single chain between groups from the panel
# - [ ] Save/restore panel state with ChimeraX sessions
# - [x] Cache pairwise results so threshold changes don't realign
# - [x] Export colour commands as .cxc

import colorsys
import html
import math
import time
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np

from Qt.QtCore import Qt
from Qt.QtGui import QColor
from Qt.QtWidgets import (
    QAbstractItemView,
    QCheckBox,
    QColorDialog,
    QComboBox,
    QDoubleSpinBox,
    QFileDialog,
    QFormLayout,
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QLineEdit,
    QPushButton,
    QTableWidget,
    QTableWidgetItem,
    QVBoxLayout,
    QWidget,
)

from chimerax.atomic import AtomicStructure, AtomicStructuresArg, Residue
from chimerax.core.commands import (
    BoolArg,
    CmdDesc,
    ColorArg,
    EnumOf,
    FloatArg,
    SaveFileNameArg,
    register,
    run,
)
from chimerax.core.models import ADD_MODELS, REMOVE_MODELS
from chimerax.core.tools import ToolInstance
from chimerax.core.triggerset import DEREGISTER
from chimerax.ui import MainToolWindow

# ==============================================================================
# Global config
# ==============================================================================

TOOL_NAME = "Homolog Colours"
COMMAND_NAME = "homcol"
SESSION_ATTR = "_homolog_colourer"  # controller stashed on the session
CACHE_ATTR = "_homolog_colour_cache"  # alignment cache survives script re-opens

DEFAULT_EVALUE = 1e-4
DEFAULT_COVERAGE = 0.5  # fraction of EACH chain covered by the local alignment
DEFAULT_IDENTITY = 0.0  # percent
DEFAULT_PALETTE = "catppuccin-mocha"
DEFAULT_FALLBACK = "#c8c8c8"

# Greys removed from the palettes so they never clash with the fallback colour
PALETTES = {
    "tab10": [
        "#1f77b4",
        "#ff7f0e",
        "#2ca02c",
        "#d62728",
        "#9467bd",
        "#8c564b",
        "#e377c2",
        "#bcbd22",
        "#17becf",
    ],
    "okabe-ito": [
        "#e69f00",
        "#56b4e9",
        "#009e73",
        "#f0e442",
        "#0072b2",
        "#d55e00",
        "#cc79a7",
    ],
    "tol-muted": [
        "#cc6677",
        "#332288",
        "#ddcc77",
        "#117733",
        "#88ccee",
        "#882255",
        "#44aa99",
        "#999933",
        "#aa4499",
    ],
    "set2": [
        "#66c2a5",
        "#fc8d62",
        "#8da0cb",
        "#e78ac3",
        "#a6d854",
        "#ffd92f",
        "#e5c494",
    ],
    "paired": [
        "#a6cee3",
        "#1f78b4",
        "#b2df8a",
        "#33a02c",
        "#fb9a99",
        "#e31a1c",
        "#fdbf6f",
        "#ff7f00",
        "#cab2d6",
        "#6a3d9a",
        "#ffff99",
        "#b15928",
    ],
    "pastel": [
        "#fbb4ae",
        "#b3cde3",
        "#ccebc5",
        "#decbe4",
        "#fed9a6",
        "#ffffcc",
        "#e5d8bd",
        "#fddaec",
    ],
    "aussie": [
        "#009392",
        "#39b185",
        "#9ccb86",
        "#e9e29c",
        "#eeb479",
        "#e88471",
    ],
    "catppuccin-mocha": [
        "#f2cdcd",
        "#cba6f7",
        "#f38ba8",
        "#eba0ac",
        "#fab387",
        "#f9e2af",
        "#a6e3a1",
        "#94e2d5",
        "#89dceb",
        "#74c7ec",
        "#89b4fa",
        "#b4befe",
    ],
}

# Scoring: BLOSUM62 with BLAST-default affine gaps (cost of a k-long gap = 11 + k)
GAP_OPEN = 11
GAP_EXTEND = 1
KA_LAMBDA = 0.267  # Karlin-Altschul, BLOSUM62 11/1 gapped
KA_K = 0.041

NEG32 = -(2**30)  # "minus infinity" with headroom for int32 arithmetic
BIG32 = 2**17  # per-target offset restarting the running max in batched SW
# WARN: BIG32 must exceed (max local score + GAP_EXTEND * chain length), i.e.
# chains up to ~10k residues; and BIG32 * targets-per-call must fit int32 (<16k).

AA_ALPHABET = "ARNDCQEGHILKMFPSTWYVBZX*"
BLOSUM62_ROWS = """
 4 -1 -2 -2  0 -1 -1  0 -2 -1 -1 -1 -1 -2 -1  1  0 -3 -2  0 -2 -1  0 -4
-1  5  0 -2 -3  1  0 -2  0 -3 -2  2 -1 -3 -2 -1 -1 -3 -2 -3 -1  0 -1 -4
-2  0  6  1 -3  0  0  0  1 -3 -3  0 -2 -3 -2  1  0 -4 -2 -3  3  0 -1 -4
-2 -2  1  6 -3  0  2 -1 -1 -3 -4 -1 -3 -3 -1  0 -1 -4 -3 -3  4  1 -1 -4
 0 -3 -3 -3  9 -3 -4 -3 -3 -1 -1 -3 -1 -2 -3 -1 -1 -2 -2 -1 -3 -3 -2 -4
-1  1  0  0 -3  5  2 -2  0 -3 -2  1  0 -3 -1  0 -1 -2 -1 -2  0  3 -1 -4
-1  0  0  2 -4  2  5 -2  0 -3 -3  1 -2 -3 -1  0 -1 -3 -2 -2  1  4 -1 -4
 0 -2  0 -1 -3 -2 -2  6 -2 -4 -4 -2 -3 -3 -2  0 -2 -2 -3 -3 -1 -2 -1 -4
-2  0  1 -1 -3  0  0 -2  8 -3 -3 -1 -2 -1 -2 -1 -2 -2  2 -3  0  0 -1 -4
-1 -3 -3 -3 -1 -3 -3 -4 -3  4  2 -3  1  0 -3 -2 -1 -3 -1  3 -3 -3 -1 -4
-1 -2 -3 -4 -1 -2 -3 -4 -3  2  4 -2  2  0 -3 -2 -1 -2 -1  1 -4 -3 -1 -4
-1  2  0 -1 -3  1  1 -2 -1 -3 -2  5 -1 -3 -1  0 -1 -3 -2 -2  0  1 -1 -4
-1 -1 -2 -3 -1  0 -2 -3 -2  1  2 -1  5  0 -2 -1 -1 -1 -1  1 -3 -1 -1 -4
-2 -3 -3 -3 -2 -3 -3 -3 -1  0  0 -3  0  6 -4 -2 -2  1  3 -1 -3 -3 -1 -4
-1 -2 -2 -1 -3 -1 -1 -2 -2 -3 -3 -1 -2 -4  7 -1 -1 -4 -3 -2 -2 -1 -2 -4
 1 -1  1  0 -1  0  0  0 -1 -2 -2  0 -1 -2 -1  4  1 -3 -2 -2  0  0  0 -4
 0 -1  0 -1 -1 -1 -1 -2 -2 -1 -1 -1 -1 -2 -1  1  5 -2 -2  0 -1 -1  0 -4
-3 -3 -4 -4 -2 -2 -3 -2 -2 -3 -2 -3 -1  1 -4 -3 -2 11  2 -3 -4 -3 -2 -4
-2 -2 -2 -3 -2 -1 -2 -3  2 -1 -1 -2 -1  3 -3 -2 -2  2  7 -1 -3 -2 -1 -4
 0 -3 -3 -3 -1 -2 -2 -3 -3  3  1 -2  1 -1 -2 -2  0 -3 -1  4 -3 -2 -1 -4
-2 -1  3  4 -3  0  1 -1  0 -3 -4  0 -3 -3 -2  0 -1 -4 -3 -3  4  1 -1 -4
-1  0  0  1 -3  3  4 -2  0 -3 -3  1 -1 -3 -1  0 -1 -3 -2 -2  1  4 -1 -4
 0 -1 -1 -1 -2 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2  0  0 -2 -1 -1 -1 -1 -1 -4
-4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4  1
"""

# Extra row/column for the separator between concatenated targets
SEP = len(AA_ALPHABET)
SCORE = np.full((SEP + 1, SEP + 1), NEG32, dtype=np.int64)
SCORE[:SEP, :SEP] = np.array(BLOSUM62_ROWS.split(), dtype=np.int64).reshape(SEP, SEP)
SCORE32 = SCORE.astype(np.int32)

# ASCII -> alphabet index; anything unknown (U, O, ?, -) maps to X
AA_LUT = np.full(256, AA_ALPHABET.index("X"), dtype=np.int64)
for _i, _c in enumerate(AA_ALPHABET):
    AA_LUT[ord(_c)] = _i
    AA_LUT[ord(_c.lower())] = _i


# ==============================================================================
# Data containers
# ==============================================================================


@dataclass
class Settings:
    evalue: float = DEFAULT_EVALUE
    min_coverage: float = DEFAULT_COVERAGE
    min_identity: float = DEFAULT_IDENTITY
    palette: str = DEFAULT_PALETTE
    fallback: str = DEFAULT_FALLBACK
    colour_atoms: bool = True
    colour_cartoons: bool = True
    colour_surfaces: bool = True
    hetero_by_element: bool = True
    auto_update: bool = False


@dataclass
class ChainRec:
    model_id: str  # ChimeraX id string, e.g. "1" or "3.2"
    chain_id: str
    seq: str
    description: str

    @property
    def spec(self) -> str:
        return f"#{self.model_id}/{self.chain_id}"


@dataclass
class Hit:
    score: int
    evalue: float
    identity: float | None = (
        None  # percent, BLAST-style (identities / alignment columns)
    )
    cov_a: float | None = None
    cov_b: float | None = None


@dataclass
class Group:
    members: list[ChainRec]
    colour: str
    manual: bool = False
    label: str = ""

    @property
    def spec(self) -> str:
        return chains_to_spec(self.members)

    @property
    def short(self) -> str:
        return chains_to_short(self.members)


# ==============================================================================
# Utils
# ==============================================================================


def encode(seq: str) -> np.ndarray:
    """Encode a protein sequence as indices into AA_ALPHABET.
    ---
    Args:
        seq: one-letter amino-acid sequence (any case; unknowns -> X)

    Returns:
        int64 array of alphabet indices
    """
    raw = np.frombuffer(seq.encode("ascii", "replace"), dtype=np.uint8)
    return AA_LUT[raw]


def evalue_from_score(score: int, m: int, n: int) -> float:
    """Karlin-Altschul E-value for a local alignment score.
    ---
    Args:
        score: raw Smith-Waterman score
        m, n: sequence lengths

    Returns:
        expected number of chance hits with at least this score
    """
    bits = (KA_LAMBDA * score - math.log(KA_K)) / math.log(2)
    return m * n * 2.0 ** (-bits)


def chains_to_short(chains: list[ChainRec]) -> str:
    """'#1/A,B #5/F' style compact listing, preserving order of appearance."""
    by_model: dict[str, list[str]] = defaultdict(list)
    for ch in chains:
        by_model[ch.model_id].append(ch.chain_id)
    return " ".join(f"#{m}/{','.join(ids)}" for m, ids in by_model.items())


def chains_to_spec(chains: list[ChainRec]) -> str:
    """Atomspec for the polymer residues of a set of chains.
    ---
    Args:
        chains: chain records

    Returns:
        e.g. '(#1/A,B | #5/F) & protein' (ligands sharing a chain ID excluded)
    """
    # WARN: chain IDs with spaces/odd characters (rare, some assembly files)
    # would need quoting in an atomspec; not handled.
    parts = chains_to_short(chains).split(" ")
    return f"({' | '.join(parts)}) & protein"


def colour_name(index: int) -> str:
    """Letters-only ChimeraX colour name for group `index` (homcola, ..., homcolaa).

    Named colours are used instead of hex in `color <spec> <colour>` because a
    hex value like #1f77b4 directly after an atomspec can be read as a model
    spec (#1...). Defining it once via `color name` side-steps the ambiguity
    and makes exported .cxc files readable.
    """
    if index < 0:
        return "homcolother"
    letters = ""
    index += 1
    while index:
        index, rem = divmod(index - 1, 26)
        letters = chr(ord("a") + rem) + letters
    return f"homcol{letters}"


def palette_colour(palette: str, index: int) -> str:
    """Palette colour for group `index`; golden-angle hues once the palette runs out."""
    colours = PALETTES.get(palette, PALETTES[DEFAULT_PALETTE])
    if index < len(colours):
        return colours[index]
    hue = ((index - len(colours)) * 0.618033988749895 + 0.11) % 1.0
    r, g, b = colorsys.hsv_to_rgb(hue, 0.55, 0.85)
    return f"#{int(r * 255):02x}{int(g * 255):02x}{int(b * 255):02x}"


# ==============================================================================
# Alignment core (numpy Smith-Waterman, affine gaps)
# ==============================================================================
#
# Row-wise vectorisation (Gotoh recurrences, gap of length k costs GO + GE*k):
#   F[i,j] = max(H[i-1,j] - GO - GE, F[i-1,j] - GE)            vertical, vectorised over j
#   H0[i,j] = max(0, H[i-1,j-1] + s(a_i, b_j), F[i,j])
#   E[i,j] = max_{k<j} (H0[i,k] - GO - GE*(j-k))               horizontal, one cumulative max
#   H[i,j] = max(H0[i,j], E[i,j])
# Using H0 instead of H inside E is exact when GO >= 0: reopening a gap from a
# cell whose best value already came from a horizontal gap is never better than
# extending that gap.


def sw_scores_vs_many(query: np.ndarray, targets: list[np.ndarray]) -> np.ndarray:
    """Best local alignment score of `query` against each target, in one pass.
    ---
    Targets are concatenated with separator columns. The horizontal-gap ramp
    restarts inside each target, and a per-target offset (BIG) added before
    the cumulative max makes the max restart at every boundary, so no gap can
    run from one target into the next. int32 throughout for speed.

    Args:
        query: encoded query sequence
        targets: encoded target sequences (< ~16k per call)

    Returns:
        int64 array of scores, one per target
    """
    lens = np.array([len(t) for t in targets], dtype=np.int64)
    pieces = []
    for t in targets:
        pieces.append(t)
        pieces.append(np.array([SEP], dtype=np.int64))
    cat = np.concatenate(pieces[:-1])
    n_cols = len(cat)

    # Full-row index 0 is the left boundary; index k >= 1 is cat[k-1].
    # A segment = [boundary/separator, residues of one target]; pos restarts at 0.
    seg_len = lens + 1
    seg = np.repeat(np.arange(len(targets), dtype=np.int64), seg_len)
    pos = np.arange(n_cols + 1, dtype=np.int64) - np.repeat(
        np.cumsum(seg_len) - seg_len, seg_len
    )
    shift = (GAP_EXTEND * pos + BIG32 * seg).astype(np.int32)
    shift_go = (shift[1:] + GAP_OPEN).astype(np.int32)
    prof = SCORE32[:, cat]  # (alphabet, n_cols) score profile of the target strip

    h_prev = np.zeros(n_cols + 1, dtype=np.int32)
    h_cur = np.zeros(n_cols + 1, dtype=np.int32)
    f = np.full(n_cols, NEG32, dtype=np.int32)
    h0 = np.empty(n_cols, dtype=np.int32)
    tmp = np.empty(n_cols, dtype=np.int32)
    work = np.zeros(n_cols + 1, dtype=np.int32)
    best = np.zeros(n_cols + 1, dtype=np.int32)
    go1 = GAP_OPEN + GAP_EXTEND

    for r in query:
        np.subtract(h_prev[1:], go1, out=tmp)  # F: vertical gaps
        np.subtract(f, GAP_EXTEND, out=f)
        np.maximum(f, tmp, out=f)
        np.add(h_prev[:-1], prof[r], out=h0)  # diagonal
        np.maximum(h0, f, out=h0)
        np.maximum(h0, 0, out=h0)
        np.add(h0, shift[1:], out=work[1:])  # E: horizontal gaps via running max
        np.maximum.accumulate(work, out=work)
        np.subtract(work[:-1], shift_go, out=tmp)
        np.maximum(h0, tmp, out=h_cur[1:])
        np.maximum(best, h_cur, out=best)
        h_prev, h_cur = h_cur, h_prev

    starts = np.concatenate(([0], np.cumsum(seg_len)[:-1]))
    return np.maximum.reduceat(best[1:], starts).astype(np.int64)


def sw_align_stats(a: np.ndarray, b: np.ndarray) -> tuple[int, float, float, float]:
    """Smith-Waterman with traceback for one pair.
    ---
    Only the H matrix is stored; gap origins are recovered during traceback by
    searching the row/column for the cell that opened the gap.

    Args:
        a, b: encoded sequences

    Returns:
        (score, percent identity, coverage of a, coverage of b)
    """
    m, n = len(a), len(b)
    H = np.zeros((m + 1, n + 1), dtype=np.int64)
    S = SCORE[a][:, b]
    ramp = GAP_EXTEND * np.arange(n + 1, dtype=np.int64)
    f_prev = np.full(n, NEG32, dtype=np.int64)
    work = np.zeros(n + 1, dtype=np.int64)
    go1 = GAP_OPEN + GAP_EXTEND

    for i in range(1, m + 1):
        f_cur = np.maximum(H[i - 1, 1:] - go1, f_prev - GAP_EXTEND)
        h0 = np.maximum(H[i - 1, :-1] + S[i - 1], f_cur)
        np.maximum(h0, 0, out=h0)
        work[1:] = h0 + ramp[1:]
        acc = np.maximum.accumulate(work)
        np.maximum(h0, acc[:-1] - GAP_OPEN - ramp[1:], out=H[i, 1:])
        f_prev = f_cur

    i, j = np.unravel_index(int(np.argmax(H)), H.shape)
    score = int(H[i, j])
    if score == 0:
        return 0, 0.0, 0.0, 0.0
    a_end, b_end = i, j
    ident = length = 0

    ############# traceback ###################
    while i > 0 and j > 0 and H[i, j] > 0:
        h = H[i, j]
        if h == H[i - 1, j - 1] + S[i - 1, j - 1]:
            ident += int(a[i - 1] == b[j - 1])
            length += 1
            i -= 1
            j -= 1
            continue
        ks = np.arange(j)
        hits = np.nonzero(H[i, :j] - GAP_OPEN - GAP_EXTEND * (j - ks) == h)[0]
        if hits.size:
            k = int(hits[-1])
            length += j - k
            j = k
            continue
        ks = np.arange(i)
        hits = np.nonzero(H[:i, j] - GAP_OPEN - GAP_EXTEND * (i - ks) == h)[0]
        k = int(hits[-1])  # must exist if the recurrence is consistent
        length += i - k
        i = k

    return score, 100.0 * ident / max(length, 1), (a_end - i) / m, (b_end - j) / n


# ==============================================================================
# Controller (analysis + colouring; no Qt)
# ==============================================================================


class HomologColourer:
    """Holds settings, alignment cache and current groups for one session."""

    def __init__(self, session):
        self.session = session
        self.settings = Settings()
        self.scope: list | None = None  # None = all atomic structures
        self.chains: list[ChainRec] = []
        self.groups: list[Group] = []
        self.singletons: list[ChainRec] = []
        self.tool = None
        self._busy = False
        self._pending_update = False
        self.cache: dict[tuple[str, str], Hit] = (
            getattr(session, CACHE_ATTR, None) or {}
        )
        setattr(session, CACHE_ATTR, self.cache)
        self._handlers = [
            session.triggers.add_handler(ADD_MODELS, self._models_changed),
            session.triggers.add_handler(REMOVE_MODELS, self._models_changed),
        ]

    def destroy(self):
        for h in self._handlers:
            try:
                self.session.triggers.remove_handler(h)
            except Exception:
                pass
        self._handlers = []
        if self.tool is not None:
            try:
                self.tool.delete()
            except Exception:
                pass
            self.tool = None

    ##### chain collection #####

    def structures(self) -> list:
        if self.scope is not None:
            self.scope = [s for s in self.scope if not s.deleted]
            structs = list(self.scope)
        else:
            structs = [m for m in self.session.models if isinstance(m, AtomicStructure)]
        return sorted(structs, key=lambda s: s.id)

    def collect_chains(self) -> list[ChainRec]:
        recs = []
        for s in self.structures():
            for ch in s.chains:
                if ch.polymer_type != Residue.PT_AMINO:
                    continue
                seq = ch.characters
                if not seq:
                    continue
                recs.append(
                    ChainRec(s.id_string, ch.chain_id, seq, ch.description or "")
                )
        return recs

    ##### alignment #####

    def _pair(self, sa: str, sb: str) -> Hit | None:
        return self.cache.get((sa, sb) if sa <= sb else (sb, sa))

    def align_missing(self, useqs: list[str]) -> int:
        """Score every not-yet-cached pair of unique sequences.
        ---
        Args:
            useqs: unique sequences

        Returns:
            number of pairs newly aligned
        """
        logger = self.session.logger
        enc = {s: encode(s) for s in useqs}
        n_new = 0
        for qi, sq in enumerate(useqs):
            todo = [st for st in useqs[qi + 1 :] if self._pair(sq, st) is None]
            if not todo:
                continue
            scores = np.concatenate(
                [
                    sw_scores_vs_many(enc[sq], [enc[st] for st in todo[c : c + 4000]])
                    for c in range(
                        0, len(todo), 4000
                    )  # keeps BIG32 * targets inside int32
                ]
            )
            for st, sc in zip(todo, scores):
                key = (sq, st) if sq <= st else (st, sq)
                self.cache[key] = Hit(
                    int(sc), evalue_from_score(int(sc), len(sq), len(st))
                )
            n_new += len(todo)
            logger.status(f"{TOOL_NAME}: aligned {qi + 1}/{len(useqs)} unique chains")
            if getattr(self.session.ui, "is_gui", False):
                self.session.ui.processEvents()
        return n_new

    def passes(self, sa: str, sb: str) -> bool:
        hit = self._pair(sa, sb)
        st = self.settings
        if hit is None or hit.evalue > st.evalue:
            return False
        if hit.identity is None:  # lazy traceback, only for E-value hits
            a, b = (sa, sb) if sa <= sb else (sb, sa)
            _, hit.identity, hit.cov_a, hit.cov_b = sw_align_stats(encode(a), encode(b))
        return (
            min(hit.cov_a, hit.cov_b) >= st.min_coverage
            and hit.identity >= st.min_identity
        )

    ##### grouping #####

    def compute(self, apply: bool = True, log: bool = True) -> None:
        """Collect chains, align new pairs, rebuild groups, (re)colour.
        ---
        Args:
            apply: run the colouring commands afterwards
            log: write a summary table to the ChimeraX log
        """
        if self._busy:
            return
        self._busy = True
        try:
            t0 = time.perf_counter()
            old_manual = {
                ch.spec: g.colour for g in self.groups if g.manual for ch in g.members
            }
            self.chains = self.collect_chains()

            useqs = list(dict.fromkeys(ch.seq for ch in self.chains))
            n_new = self.align_missing(useqs)

            ############# union-find over unique sequences ###################
            parent = list(range(len(useqs)))

            def find(x):
                while parent[x] != x:
                    parent[x] = parent[parent[x]]
                    x = parent[x]
                return x

            for i in range(len(useqs)):
                for j in range(i + 1, len(useqs)):
                    if find(i) != find(j) and self.passes(useqs[i], useqs[j]):
                        parent[find(i)] = find(j)

            seq_index = {s: i for i, s in enumerate(useqs)}
            comps: dict[int, list[ChainRec]] = {}
            for ch in self.chains:  # chains are already in order of appearance
                comps.setdefault(find(seq_index[ch.seq]), []).append(ch)

            self.groups, self.singletons = [], []
            for members in comps.values():
                if len(members) == 1:
                    self.singletons.append(members[0])
                    continue
                descs = Counter(m.description for m in members if m.description)
                label = descs.most_common(1)[0][0] if descs else ""
                self.groups.append(Group(members, "", label=label))

            self.assign_colours(keep=old_manual)
            dt = time.perf_counter() - t0
            self.session.logger.status(
                f"{TOOL_NAME}: {len(self.groups)} groups, {len(self.singletons)} unmatched "
                f"({len(self.chains)} chains, {len(useqs)} unique, {n_new} new pairs, {dt:.1f}s)"
            )
            if log:
                self.log_summary(len(useqs), n_new, dt)
        finally:
            self._busy = False

        if apply:
            self.apply()
        if self.tool is not None:
            self.tool.refresh()

    def assign_colours(
        self, keep: dict[str, str] | None = None, reset: bool = False
    ) -> None:
        """Palette colours by group order; manual colours carried over by member overlap.
        ---
        Args:
            keep: chain spec -> manual hex colour from a previous grouping
            reset: discard all manual colours
        """
        for i, g in enumerate(self.groups):
            carried = None
            if keep and not reset:
                carried = next(
                    (keep[ch.spec] for ch in g.members if ch.spec in keep), None
                )
            if carried is not None:
                g.colour, g.manual = carried, True
            elif reset or not g.manual:
                g.colour, g.manual = palette_colour(self.settings.palette, i), False

    ##### colouring #####

    def colour_of(self, index: int) -> str:
        return self.settings.fallback if index < 0 else self.groups[index].colour

    def members_of(self, index: int) -> list[ChainRec]:
        return self.singletons if index < 0 else self.groups[index].members

    def commands(self, indices: list[int] | None = None) -> list[str]:
        """ChimeraX commands that apply the current colours.
        ---
        Args:
            indices: group indices (-1 = unmatched); None = all

        Returns:
            command strings
        """
        st = self.settings
        if indices is None:
            indices = list(range(len(self.groups))) + [-1]
        target = ""
        target += "af" if st.colour_atoms else ""
        target += "c" if st.colour_cartoons else ""
        target += "s" if st.colour_surfaces else ""
        cmds = []
        for idx in indices:
            members = self.members_of(idx)
            if not members:
                continue
            name, spec = colour_name(idx), chains_to_spec(members)
            cmds.append(f"color name {name} {self.colour_of(idx)}")
            if target:
                cmds.append(f"color {spec} {name} target {target}")
            if st.colour_atoms and st.hetero_by_element:
                cmds.append(f"color {spec} byhetero")
        return cmds

    def apply(self, indices: list[int] | None = None) -> None:
        for cmd in self.commands(indices):
            run(self.session, cmd, log=False)

    def set_colour(
        self, index: int, hexcol: str, manual: bool = True, apply: bool = True
    ) -> None:
        if index < 0:
            self.settings.fallback = hexcol
        else:
            self.groups[index].colour = hexcol
            self.groups[index].manual = manual
        if apply:
            self.apply([index])

    def select(self, index: int) -> None:
        members = self.members_of(index)
        if members:
            run(self.session, f"select {chains_to_spec(members)}")

    def export(self, path: str | Path) -> Path:
        path = Path(path).expanduser()
        path.parent.mkdir(parents=True, exist_ok=True)
        st = self.settings
        lines = [
            f"# {TOOL_NAME}: evalue {st.evalue:g}, coverage {st.min_coverage:g}, "
            f"identity {st.min_identity:g}, palette {st.palette}",
        ]
        for i, g in enumerate(self.groups):
            lines.append(
                f"# {colour_name(i)}: {g.label or 'group ' + str(i + 1)} -- {g.short}"
            )
        if self.singletons:
            lines.append(
                f"# {colour_name(-1)}: unmatched -- {chains_to_short(self.singletons)}"
            )
        lines += self.commands()
        with open(path, "w") as fh:
            fh.write("\n".join(lines) + "\n")
        self.session.logger.info(f"{TOOL_NAME}: wrote {len(lines)} lines to {path}")
        return path

    def log_summary(self, n_unique: int, n_new: int, dt: float) -> None:
        def swatch(c):
            return (
                f'<span style="display:inline-block;width:1.2em;height:0.9em;'
                f'background:{c};border:1px solid #555"></span>'
            )

        rows = [
            f"<tr><td>{swatch(g.colour)}</td><td>{colour_name(i)}</td>"
            f"<td>{html.escape(g.label)}</td><td>{html.escape(g.short)}</td></tr>"
            for i, g in enumerate(self.groups)
        ]
        if self.singletons:
            rows.append(
                f"<tr><td>{swatch(self.settings.fallback)}</td><td>{colour_name(-1)}</td>"
                f"<td><i>no homologue</i></td><td>{html.escape(chains_to_short(self.singletons))}</td></tr>"
            )
        self.session.logger.info(
            f"<b>{TOOL_NAME}</b>: {len(self.chains)} protein chains, {n_unique} unique sequences, "
            f"{n_new} new alignments, {dt:.1f} s<br>"
            f'<table style="border-collapse:collapse" cellpadding="2">{"".join(rows)}</table>',
            is_html=True,
        )

    ##### model add/remove #####

    def _models_changed(self, trigger_name, models):
        if not any(isinstance(m, AtomicStructure) for m in models):
            return
        if trigger_name == ADD_MODELS and not self.settings.auto_update:
            return
        if not self._pending_update:
            self._pending_update = True
            # Defer: models are mid-construction / mid-styling inside this trigger
            self.session.triggers.add_handler("new frame", self._deferred_update)

    def _deferred_update(self, *_):
        self._pending_update = False
        # Removal without auto-update only prunes dead chains (no recolouring)
        self.compute(apply=self.settings.auto_update, log=False)
        return DEREGISTER


# ==============================================================================
# GUI panel
# ==============================================================================


class HomologColourTool(ToolInstance):
    SESSION_ENDURING = False
    SESSION_SAVE = False

    def __init__(self, session, ctl: HomologColourer):
        super().__init__(session, TOOL_NAME)
        self.ctl = ctl
        self.tool_window = MainToolWindow(self)
        self._build(self.tool_window.ui_area)
        self.tool_window.manage(placement="side")
        self.refresh()

    def delete(self):
        if self.ctl.tool is self:
            self.ctl.tool = None
        super().delete()

    ##### layout #####

    def _build(self, parent: QWidget) -> None:
        st = self.ctl.settings
        layout = QVBoxLayout(parent)
        layout.setContentsMargins(4, 4, 4, 4)
        layout.setSpacing(4)

        form = QFormLayout()
        form.setContentsMargins(0, 0, 0, 0)

        self.ev_edit = QLineEdit(f"{st.evalue:g}")
        self.ev_edit.setToolTip(
            "Max E-value (BLOSUM62 11/1 local alignment) for two chains to be linked"
        )
        self.ev_edit.editingFinished.connect(self._thresholds_changed)
        form.addRow("E-value ≤", self.ev_edit)

        self.cov_spin = QDoubleSpinBox()
        self.cov_spin.setRange(0.0, 1.0)
        self.cov_spin.setSingleStep(0.05)
        self.cov_spin.setDecimals(2)
        self.cov_spin.setKeyboardTracking(False)
        self.cov_spin.setValue(st.min_coverage)
        self.cov_spin.setToolTip("Min fraction of BOTH chains covered by the alignment")
        self.cov_spin.valueChanged.connect(self._thresholds_changed)
        form.addRow("Coverage ≥", self.cov_spin)

        self.id_spin = QDoubleSpinBox()
        self.id_spin.setRange(0.0, 100.0)
        self.id_spin.setSingleStep(5.0)
        self.id_spin.setDecimals(0)
        self.id_spin.setSuffix(" %")
        self.id_spin.setKeyboardTracking(False)
        self.id_spin.setValue(st.min_identity)
        self.id_spin.valueChanged.connect(self._thresholds_changed)
        form.addRow("Identity ≥", self.id_spin)

        self.palette_combo = QComboBox()
        self.palette_combo.addItems(list(PALETTES))
        self.palette_combo.setCurrentText(st.palette)
        self.palette_combo.currentTextChanged.connect(self._palette_changed)
        form.addRow("Palette", self.palette_combo)
        layout.addLayout(form)

        ############# colouring targets ###################
        targets = QHBoxLayout()
        targets.addWidget(QLabel("Colour:"))
        self.cb_atoms = self._checkbox("Atoms", st.colour_atoms, targets)
        self.cb_cartoon = self._checkbox("Cartoon", st.colour_cartoons, targets)
        self.cb_surface = self._checkbox("Surfaces", st.colour_surfaces, targets)
        self.cb_hetero = self._checkbox(
            "Hetero by element", st.hetero_by_element, targets
        )
        targets.addStretch(1)
        layout.addLayout(targets)

        self.cb_auto = QCheckBox("Auto-update when models are opened/closed")
        self.cb_auto.setChecked(st.auto_update)
        self.cb_auto.toggled.connect(
            lambda v: setattr(self.ctl.settings, "auto_update", v)
        )
        layout.addWidget(self.cb_auto)

        ############# buttons ###################
        buttons = QHBoxLayout()
        for text, slot, tip in (
            ("Recompute", self._recompute, "Re-scan open models and regroup"),
            ("Reset colours", self._reset, "Discard manual colours, back to palette"),
            ("Export .cxc…", self._export, "Save the colouring as ChimeraX commands"),
        ):
            b = QPushButton(text)
            b.setToolTip(tip)
            b.clicked.connect(slot)
            buttons.addWidget(b)
        buttons.addStretch(1)
        layout.addLayout(buttons)

        self.summary = QLabel()
        layout.addWidget(self.summary)

        ############# groups table ###################
        self.table = QTableWidget(0, 4)
        self.table.setHorizontalHeaderLabels(["", "Group", "Chains", ""])
        self.table.verticalHeader().setVisible(False)
        self.table.setSelectionMode(QAbstractItemView.SelectionMode.NoSelection)
        self.table.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        self.table.setWordWrap(True)
        hdr = self.table.horizontalHeader()
        hdr.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        hdr.setSectionResizeMode(1, QHeaderView.ResizeMode.Interactive)
        hdr.setSectionResizeMode(2, QHeaderView.ResizeMode.Stretch)
        hdr.setSectionResizeMode(3, QHeaderView.ResizeMode.ResizeToContents)
        self.table.setColumnWidth(1, 150)
        layout.addWidget(self.table, 1)

    def _checkbox(self, text: str, checked: bool, row: QHBoxLayout) -> QCheckBox:
        cb = QCheckBox(text)
        cb.setChecked(checked)
        cb.toggled.connect(self._targets_changed)
        row.addWidget(cb)
        return cb

    @staticmethod
    def _swatch(hexcol: str) -> QPushButton:
        b = QPushButton()
        b.setFixedSize(38, 20)
        b.setToolTip(f"{hexcol} — click to change")
        b.setStyleSheet(
            f"QPushButton {{ background-color: {hexcol}; border: 1px solid #555; }}"
        )
        return b

    ##### refresh #####

    def refresh(self) -> None:
        ctl = self.ctl
        if ctl.scope is None:
            scope = "all models"
        else:
            scope = " ".join(f"#{s.id_string}" for s in ctl.structures()) or "none"
        self.summary.setText(
            f"{len(ctl.groups)} homolog groups, {len(ctl.singletons)} unmatched "
            f"({len(ctl.chains)} protein chains; scope: {scope})"
        )
        rows = list(range(len(ctl.groups))) + [-1]
        self.table.clearContents()  # drop old cell widgets before rebuilding
        self.table.setRowCount(0)
        self.table.setRowCount(len(rows))
        for r, idx in enumerate(rows):
            members = ctl.members_of(idx)
            if idx < 0:
                label = "Unmatched (fallback)"
            else:
                g = ctl.groups[idx]
                label = f"{idx + 1}. {g.label}" if g.label else f"Group {idx + 1}"
                label += " ✎" if g.manual else ""

            sw = self._swatch(ctl.colour_of(idx))
            sw.clicked.connect(lambda _=False, i=idx: self._pick_colour(i))
            self.table.setCellWidget(r, 0, sw)

            item = QTableWidgetItem(label)
            item.setToolTip(label)
            self.table.setItem(r, 1, item)

            short = chains_to_short(members) if members else "(none)"
            item = QTableWidgetItem(short)
            item.setToolTip(f"{len(members)} chains: {short}")
            self.table.setItem(r, 2, item)

            sel = QPushButton("Select")
            sel.setEnabled(bool(members))
            sel.clicked.connect(lambda _=False, i=idx: self.ctl.select(i))
            self.table.setCellWidget(r, 3, sel)
        self.table.resizeRowsToContents()

    ##### slots #####

    def _pick_colour(self, idx: int) -> None:
        ctl = self.ctl
        old = ctl.colour_of(idx)
        old_manual = ctl.groups[idx].manual if idx >= 0 else True
        dlg = QColorDialog(QColor(old), self.tool_window.ui_area)
        dlg.setWindowTitle(
            f"{TOOL_NAME}: {'unmatched chains' if idx < 0 else f'group {idx + 1}'}"
        )
        dlg.currentColorChanged.connect(
            lambda c: ctl.set_colour(idx, c.name())
        )  # live preview
        if dlg.exec():
            ctl.set_colour(idx, dlg.selectedColor().name(), manual=True)
        else:
            ctl.set_colour(idx, old, manual=old_manual)
        self.refresh()

    def _thresholds_changed(self, *_):
        st = self.ctl.settings
        try:
            ev = float(self.ev_edit.text())
            if ev <= 0:
                raise ValueError
            st.evalue = ev
        except ValueError:
            self.ev_edit.setText(f"{st.evalue:g}")
        new = (st.evalue, self.cov_spin.value(), self.id_spin.value())
        if new == getattr(self, "_last_thresholds", None):
            return
        self._last_thresholds = new
        st.min_coverage, st.min_identity = new[1], new[2]
        self.ctl.compute()

    def _palette_changed(self, name: str) -> None:
        self.ctl.settings.palette = name
        self.ctl.assign_colours()
        self.ctl.apply()
        self.refresh()

    def _targets_changed(self, *_):
        st = self.ctl.settings
        st.colour_atoms = self.cb_atoms.isChecked()
        st.colour_cartoons = self.cb_cartoon.isChecked()
        st.colour_surfaces = self.cb_surface.isChecked()
        st.hetero_by_element = self.cb_hetero.isChecked()
        self.ctl.apply()

    def _recompute(self):
        self.ctl.compute()

    def _reset(self):
        self.ctl.assign_colours(reset=True)
        self.ctl.apply()
        self.refresh()

    def _export(self):
        path, _ = QFileDialog.getSaveFileName(
            self.tool_window.ui_area,
            "Export colour commands",
            str(Path.home() / "homolog_colours.cxc"),
            "ChimeraX commands (*.cxc)",
        )
        if path:
            self.ctl.export(path)

    def sync_from_settings(self) -> None:
        """Push settings changed via the command line back into the widgets."""
        st = self.ctl.settings
        for w in (
            self.cov_spin,
            self.id_spin,
            self.palette_combo,
            self.cb_atoms,
            self.cb_cartoon,
            self.cb_surface,
            self.cb_hetero,
        ):
            w.blockSignals(True)
        self.ev_edit.setText(f"{st.evalue:g}")
        self.cov_spin.setValue(st.min_coverage)
        self.id_spin.setValue(st.min_identity)
        self.palette_combo.setCurrentText(st.palette)
        self.cb_atoms.setChecked(st.colour_atoms)
        self.cb_cartoon.setChecked(st.colour_cartoons)
        self.cb_surface.setChecked(st.colour_surfaces)
        self.cb_hetero.setChecked(st.hetero_by_element)
        for w in (
            self.cov_spin,
            self.id_spin,
            self.palette_combo,
            self.cb_atoms,
            self.cb_cartoon,
            self.cb_surface,
            self.cb_hetero,
        ):
            w.blockSignals(False)
        self._last_thresholds = (st.evalue, st.min_coverage, st.min_identity)


# ==============================================================================
# Command + entry point
# ==============================================================================


def get_controller(session, fresh: bool = False) -> HomologColourer:
    """Session-wide controller; `fresh` replaces one left by an older copy of this script."""
    ctl = getattr(session, SESSION_ATTR, None)
    if ctl is not None and (fresh or not isinstance(ctl, HomologColourer)):
        settings, scope = ctl.settings, ctl.scope
        ctl.destroy()
        ctl = HomologColourer(session)
        # keep settings across re-opens only if the dataclass is compatible
        if set(vars(settings)) == set(vars(ctl.settings)):
            ctl.settings, ctl.scope = Settings(**vars(settings)), scope
    elif ctl is None:
        ctl = HomologColourer(session)
    setattr(session, SESSION_ATTR, ctl)
    return ctl


def homcol(
    session,
    structures=None,
    evalue=None,
    coverage=None,
    identity=None,
    palette=None,
    fallback=None,
    reset=False,
    panel=True,
    export=None,
):
    """`homcol` command: group homologous chains, colour them, show the panel."""
    ctl = get_controller(session)
    st = ctl.settings
    if structures is not None:
        all_structs = [m for m in session.models if isinstance(m, AtomicStructure)]
        ctl.scope = None if len(structures) == len(all_structs) else list(structures)
    if evalue is not None:
        st.evalue = evalue
    if coverage is not None:
        st.min_coverage = coverage
    if identity is not None:
        st.min_identity = identity
    if palette is not None:
        st.palette = palette
    if fallback is not None:
        st.fallback = "#{:02x}{:02x}{:02x}".format(*fallback.uint8x4()[:3])

    if panel and getattr(session.ui, "is_gui", False) and ctl.tool is None:
        ctl.tool = HomologColourTool(session, ctl)
    if ctl.tool is not None:
        ctl.tool.sync_from_settings()
        ctl.tool.display(True)

    if reset:
        for g in ctl.groups:
            g.manual = False
    ctl.compute()
    if export is not None:
        ctl.export(export)


def register_command(session) -> None:
    desc = CmdDesc(
        optional=[("structures", AtomicStructuresArg)],
        keyword=[
            ("evalue", FloatArg),
            ("coverage", FloatArg),
            ("identity", FloatArg),
            ("palette", EnumOf(tuple(PALETTES))),
            ("fallback", ColorArg),
            ("reset", BoolArg),
            ("panel", BoolArg),
            ("export", SaveFileNameArg),
        ],
        synopsis="colour homologous protein chains consistently across models",
    )
    register(COMMAND_NAME, desc, homcol, logger=session.logger)


def main(session) -> None:
    """Workflow:
    ---
    main
     ├── register_command   (`homcol`)
     ├── get_controller     (fresh: replaces panel/handlers from a previous open)
     └── homcol             (collect -> align -> group -> colour -> panel)
    """
    register_command(session)
    get_controller(session, fresh=True)
    homcol(session)


# ChimeraX `open script.py` runs this file with `session` in its globals
if "session" in globals():
    main(globals()["session"])

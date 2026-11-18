import re
from datetime import datetime
from pathlib import Path
from chimerax.atomic import AtomicStructure
from chimerax.core.commands import run


outdir = Path.home() / "Pictures" / "ChimeraX"
outdir.mkdir(parents=True, exist_ok=True)

# visible atomic structures
shown = [m for m in session.models.list(type=AtomicStructure) if m.visible]

# unique names
names = []
for m in shown:
    n = re.sub("[^\w.-]+", "_", Path(m.name).stem)
    if n not in names:
        names.append(n)

suffix = "_" + "+".join(names) if names else ""
fname = outdir / f"{datetime.now():%Y-%m-%d_%H-%M-%S}_{suffix}.mp4"

# lower pixelSize = higher res
# high pixelSize = lower res
# pixelSize 0.02 is very high res
# pixelSize 0.1 is good for quick saves
# pixelsize = 0.08
run(
    session,
    f'movie record supersample 3; rock; wait 136; movie stop; movie encode "{fname}"; stop',
)

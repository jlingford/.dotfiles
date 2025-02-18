#!/usr/bin/env python3
"""
Plot PAE from alphafold .json files
"""

import json
import matplotlib.pyplot as plt
from pathlib import Path

path = Path(".")
for entry in path.iterdir():
    if entry.is_file():
        with entry.open("r") as f:
            data = json.load(f)

            # pae = data["predicted_aligned_error"]
            pae = data["pae"]

            # set subplots
            # fig = plt.figure()
            # ax = fig.add_subplot(1, 1, 1)
            # autocomplete does not work with this shortened syntax:
            fig, ax = plt.subplots()

            # create heatmap
            im = ax.imshow(pae, cmap="Greens_r", vmin=0, aspect="equal")

            # configure colour bar
            # fig.colorbar(im, ax=ax, label="Predicted Aligned Error (Å)")

            # labels
            # ax.set_xlabel("Scored residue")
            # ax.set_ylabel("Aligned residue")

            # move x axis to top
            ax.tick_params(top=True, labeltop=True, bottom=False, labelbottom=False)
            ax.xaxis.set_label_position("top")

            # make tick numbers equal on each axis
            # ax.set_xticks(range(0, len(pae), len(pae) - 1))
            ax.set_xticks([])
            ax.set_yticks([])

            # saving figures
            plt.savefig(
                f"./PAE_plots/{entry}.png", format="png", dpi=300, transparent=True
            )
            plt.close()
            # plt.show()

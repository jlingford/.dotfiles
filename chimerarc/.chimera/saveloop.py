from chimerax.core.commands import run
from pathlib import Path

# Set your output directory
outdir = Path("/home/james/Pictures/ChimeraX")
outdir.mkdir(exist_ok=True)

# Get all currently open models
models = session.models.list()

for model in models:
    model_id = model.id_string  # e.g. "1", "2.1"
    model_name = model.name  # e.g. "GCF_000006945"

    # Hide all models, then show just this one
    run(session, "hide models")
    run(session, f"show #{model_id} models")

    # Focus view on this model
    # run(session, f"view #{model_id}")

    # Save png
    # outpath = outdir / f"{model_id}_{model_name}.png"
    outpath = outdir / f"{model_id}_{model_name}.png"
    if outpath.exists():
        outpath.unlink()

    run(
        session,
        f"save {outpath} format png width 2000 height 2000 transparentB t supersample 8",
    )

# Restore all models visible when done
run(session, "show models")

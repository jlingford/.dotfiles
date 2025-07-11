return {
  "GCBallesteros/jupytext.nvim",
  config = true,
  -- Depending on your nvim distro or config you may need to make the loading not lazy
  -- lazy=false,
  -- WARN: requires a venv with "pip install jupytext" ran
  -- require("jupytext").setup({
  --   style = "markdown",
  --   output_extension = "md",
  --   force_ft = "markdown",
  -- }),
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}

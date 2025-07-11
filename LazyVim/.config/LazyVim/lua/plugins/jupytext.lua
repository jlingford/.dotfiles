return {
  "GCBallesteros/jupytext.nvim",
  config = true,
  -- WARN: do not try lazy loading, just won't work...
  lazy = false,
  -- WARN: requires a venv with "pip install jupytext" already installed!!
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}

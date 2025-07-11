return {
  "GCBallesteros/jupytext.nvim",
  config = true,
  -- WARN: do not try lazy loading, just won't work...
  -- Depending on your nvim distro or config you may need to make the loading not lazy
  -- lazy=false,
  -- WARN: requires a venv with "pip install jupytext" ran
  -- require("jupytext").setup({
  --   style = "markdown",
  --   output_extension = "md",
  --   force_ft = "markdown",
  -- }),
  -- event = "VeryLazy",
  -- ft = { "markdown", "quarto", "ipynb", "json" },
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}

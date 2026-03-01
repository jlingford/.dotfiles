return {
  "GCBallesteros/jupytext.nvim",
  config = true,
  -- WARN: do not try lazy loading, just won't work...
  lazy = false,
  -- WARN: requires a venv with "pip install jupytext" already installed and ACTIVATED!!!
  opts = {
    -- -- old config
    -- style = "markdown",
    -- output_extension = "md",
    -- force_ft = "markdown",
    style = "hydrogen",
    output_extension = "auto", -- don't change, apparently
    force_ft = nil, -- don't change, apparently
    -- NOTE: converts python files to quarto markdown
    custom_language_formatting = {
      python = {
        extension = "qmd",
        style = "quarto",
        force_ft = "quarto", -- you can set whatever filetype you want here
      },
    },
  },
}

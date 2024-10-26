return {
  "quarto-dev/quarto-nvim",
  enabled = false,
  ft = {
    -- { "python" },
    -- { "rmd" },
    -- { "qmd" },
    { "quarto" },
  },
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}

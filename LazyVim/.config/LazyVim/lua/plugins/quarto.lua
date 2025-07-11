return {
  "quarto-dev/quarto-nvim",
  -- enabled = false,
  event = "VeryLazy",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "quarto", "markdown", "*.ipynb" },
  -- for Molten.nvim
  -- opts = {
  --   lspFeatures = {
  --     -- NOTE: put whatever languages you want here:
  --     languages = { "r", "python", "rust", "bash" },
  --     chunks = "all",
  --     diagnostics = {
  --       enabled = true,
  --       triggers = { "BufWritePost" },
  --     },
  --     completion = {
  --       enabled = true,
  --     },
  --   },
  --   keymap = {
  --     -- NOTE: setup your own keymaps:
  --     hover = "H",
  --     definition = "gd",
  --     rename = "<leader>rn",
  --     references = "gr",
  --     format = "<leader>gf",
  --   },
  --   codeRunner = {
  --     enabled = true,
  --     default_method = "molten",
  --   },
  -- },
  config = function()
    local quarto = require("quarto")
    quarto.setup({
      lspFeatures = {
        languages = { "python", "rust", "lua" },
        chunks = "all", -- 'curly' or 'all'
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "H",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
      },
      codeRunner = {
        enabled = true,
        ft_runners = {
          bash = "slime",
        },
        default_method = "molten",
      },
    })
    -- keybinds
    vim.keymap.set(
      "n",
      "<leader>m.",
      "<cmd>QuartoActivate<cr>",
      { desc = "Quarto: activate", silent = true, noremap = true }
    )
    vim.keymap.set(
      "n",
      "<leader>mp",
      quarto.quartoPreview,
      { desc = "Quarto: Preview Quarto document", silent = true, noremap = true }
    )
    -- to create a cell in insert mode, I have the ` snippet
    vim.keymap.set("n", "<leader>mc", "i`<c-j>", { desc = "Quarto: create new code cell", silent = true })
    vim.keymap.set(
      "n",
      "<leader>m-",
      "i```\r\r```{}<left>",
      { desc = "Quarto: split code cell", silent = true, noremap = true }
    )
    -- for more keybinds that I would use in a quarto document, see the configuration for molten
    -- require("benlubas.hydra.notebook")
    -- quarto runner keybinds:
    local runner = require("quarto.runner")
    vim.keymap.set("n", "<leader>mr", runner.run_cell, { desc = "Quarto: run cell", silent = true })
    vim.keymap.set("n", "<leader>ma", runner.run_above, { desc = "Quarto: run cell and above", silent = true })
    vim.keymap.set("n", "<leader>mA", runner.run_all, { desc = "Quarto: run all cells", silent = true })
    vim.keymap.set("n", "<leader>ml", runner.run_line, { desc = "Quarto: run line", silent = true })
    vim.keymap.set("v", "<leader>mr", runner.run_range, { desc = "Quarto: run visual range", silent = true })
    vim.keymap.set("n", "<leader>mRA", function()
      runner.run_all(true)
    end, { desc = "run all cells of all languages", silent = true })
  end,
}

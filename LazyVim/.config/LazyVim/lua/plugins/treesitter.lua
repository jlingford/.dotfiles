return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { "r" },
    -- NOTE: options to work with markdown code blocks
    textobjects = {
      move = {
        enable = true,
        set_jumps = false, -- you can change this if you want.
        goto_next_start = {
          --- ... other keymaps
          ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
        },
        goto_previous_start = {
          --- ... other keymaps
          ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
        },
      },
      select = {
        enable = true,
        lookahead = true, -- you can change this if you want
        keymaps = {
          --- ... other keymaps
          ["ib"] = { query = "@code_cell.inner", desc = "in block" },
          ["ab"] = { query = "@code_cell.outer", desc = "around block" },
        },
      },
    },
    -- -- NOTE: options for R.nvim
    -- config = function()
    --   local langs = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv" }
    --   require("nvim-treesitter").install(langs)
    --
    --   vim.api.nvim_create_autocmd("FileType", {
    --     pattern = langs,
    --     callback = function()
    --       vim.treesitter.start()
    --     end,
    --   })
    -- end,
    --
    -- require("nvim-treesitter.configs").setup({
    --   textobjects = {
    --     move = {
    --       enable = true,
    --       set_jumps = false, -- you can change this if you want.
    --       goto_next_start = {
    --         --- ... other keymaps
    --         ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
    --       },
    --       goto_previous_start = {
    --         --- ... other keymaps
    --         ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
    --       },
    --     },
    --     select = {
    --       enable = true,
    --       lookahead = true, -- you can change this if you want
    --       keymaps = {
    --         --- ... other keymaps
    --         ["ib"] = { query = "@code_cell.inner", desc = "in block" },
    --         ["ab"] = { query = "@code_cell.outer", desc = "around block" },
    --       },
    --     },
    -- NOTE: change so not to override buffer grep
    -- swap = { -- Swap only works with code blocks that are under the same
    --   -- markdown header
    --   enable = true,
    --   swap_next = {
    --     --- ... other keymap
    --     ["<leader>sbl"] = "@code_cell.outer",
    --   },
    --   swap_previous = {
    --     --- ... other keymap
    --     ["<leader>sbh"] = "@code_cell.outer",
    --   },
    -- },
    --   },
    -- }),
  },
}

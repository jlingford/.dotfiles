return {
  "SUSTech-data/neopyter",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter", -- neopyter don't depend on `nvim-treesitter`, but does depend on treesitter parser of python
    "AbaoFromCUG/websocket.nvim", -- for mode='direct'
  },

  ---@type neopyter.Option
  opts = {
    mode = "direct",
    remote_address = "127.0.0.1:9001",
    file_pattern = { "*.ju.*" },
    on_attach = function(bufnr)
      -- do some buffer keymap
    end,
  },
}

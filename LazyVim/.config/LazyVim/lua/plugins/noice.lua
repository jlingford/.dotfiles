return {
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          --disable the annoying lsp popups on pyright
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              return client == "pyright"
            end,
          },
          opts = { skip = true },
        },
      },
    },
  },
}

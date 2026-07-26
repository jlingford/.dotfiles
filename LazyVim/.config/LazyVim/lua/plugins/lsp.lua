return {
  {
    "neovim/nvim-lspconfig",
    -- NOTE: R lang stuff
    require("lspconfig").r_language_server.setup({
      -- This forces the LSP to launch using the current active R environment
      cmd = { "R", "--slave", "-e", "languageserver::run()" },
    }),
    --
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },
}

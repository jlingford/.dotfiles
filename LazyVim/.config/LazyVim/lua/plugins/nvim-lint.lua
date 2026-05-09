local HOME = os.getenv("HOME")
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", HOME .. "/.dotfiles/LazyVim/.config/LazyVim/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}

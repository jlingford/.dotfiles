return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    integrations = {
        neotree = true,
        telescope = { enabled = true },
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
    },
    config = function()
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}

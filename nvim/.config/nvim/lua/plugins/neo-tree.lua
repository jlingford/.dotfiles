return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    keys = {
        {"<leader>e", "<cmd>Neotree toggle<CR>", desc = "Neotree"},
    },
    opts = {
        close_if_last_window = true,
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
        },
        window = {
            width = 30,
        },
    },
}

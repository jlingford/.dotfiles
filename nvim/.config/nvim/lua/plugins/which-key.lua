local wk = require("which-key")

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
        wk.register({
            ["<leader>f"] = {
                name = "+find (Telescope)",
            },
            ["<leader>t"] = {
                name = "+terminal",
            },
            ["<leader>gh"] = {
                name = "+git hunk",
            },
            ["<leader>b"] = {
                name = "+buffer",
            },
            ["<leader>w"] = {
                name = "+windows",
            },
            ["<leader>c"] = {
                name = "+code",
            },
            ["<leader>s"] = {
                name = "+Spectre",
            },
            ["<leader>x"] = {
                name = "+Trouble",
            },
        })
    },
}

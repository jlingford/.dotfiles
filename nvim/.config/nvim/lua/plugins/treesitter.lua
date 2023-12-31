return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            "awk",
            "bash",
            "bibtex",
            "c",
            "css",
            "go",
            "html",
            "javascript",
            "json",
            "jsonc",
            "julia",
            "latex",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "r",
            "regex",
            "rust",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
    },
}

return {
    "nvim-telescope/telescope-bibtex.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function ()
        require("telescope").load_extension("bibtex")
    end,
}

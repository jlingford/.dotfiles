return {
    "nvim-telescope/telescope-bibtex.nvim",
    -- event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },

    -- not sure how this works...
    keys = {
        {
            "<leader>fy",
            function ()
                require("telescope").extensions.bibtex.bibtex({ prompt_title = "BibTeX", format = "plain" })
            end,
            desc = "Find Bibtex",
        },
    },

    config = function ()
        require("telescope").load_extension("bibtex")
    end,
}

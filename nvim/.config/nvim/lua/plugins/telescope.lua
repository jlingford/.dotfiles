return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
        lazy = true,
        cmd = "Telescope",
		dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
        },
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- opts go here
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}

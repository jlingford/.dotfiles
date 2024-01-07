return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
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

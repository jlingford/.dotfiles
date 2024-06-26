return {
	"cshuaimin/ssr.nvim",
	-- event = "VeryLazy",
	module = "ssr",
	-- Calling setup is optional.
	config = function()
		require("ssr").setup({
			border = "rounded",
			min_width = 50,
			min_height = 5,
			max_width = 120,
			max_height = 25,
			adjust_window = true,
			keymaps = {
				close = "q",
				next_match = "n",
				prev_match = "N",
				replace_confirm = "<cr>",
				replace_all = "<leader><cr>",
			},
		})
	end,
	keys = {
		{
			"<leader>ssr",
			function()
				require("ssr").open()
			end,
			desc = "Structural search and replace",
		},
	},
}

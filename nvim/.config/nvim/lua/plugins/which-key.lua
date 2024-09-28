return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	opts_extend = { "spec" },
	opts = {
		-- your configuration comes here
		plugins = { spelling = true },
		defaults = {},
		spec = {
			mode = { "n", "v" },
			{ "<leader>f", group = "find (Telescope)" },
			{ "<leader>t", group = "terminal" },
			{ "<leader>g", group = "git" },
			{ "<leader>gh", group = "git hunks" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>w", group = "windows" },
			{ "<leader>c", group = "code" },
			{ "<leader>s", group = "Spectre" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>i", group = "Noice" },
		},
	},
}

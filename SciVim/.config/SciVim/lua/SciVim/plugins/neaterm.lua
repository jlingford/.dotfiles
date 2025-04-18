return {
	{
		"Dan7h3x/neaterm.nvim",
		branch = "devel",
		event = "VeryLazy",
		keys = { { "<F3>", "<CMD>NeatermRanger<CR>" }, { "<F4>", "<CMD>NeatermLazygit<CR>" } },
		opts = {
			repl_configs = {
				lua = {
					name = "Lua",
					cmd = "ilua",
					exit_cmd = "os.exit()",
				},
			},
		},
		dependencies = {
			-- "nvim-lua/plenary.nvim",
			-- "ibhagwan/fzf-lua",
		},
	},
}

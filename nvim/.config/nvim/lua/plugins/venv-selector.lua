return {
	"linux-cultist/venv-selector.nvim",
	branch = "regexp", -- Use this branch for the new version
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
	--  Call config for python files and load the cached venv automatically
	ft = "python",
	keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
	opts = {
		settings = {
			options = {
				notify_user_on_venv_activation = true,
			},
		},
	},
}

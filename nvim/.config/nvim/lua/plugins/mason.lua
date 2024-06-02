return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { "leader<m>", "<cmd>Mason<cr>", desc = "Mason" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- "bashls",
					-- "clangd",
					-- "cmake",
					-- "html",
					-- "jsonls",
					-- "lua_ls",
					-- "marksman",
					-- "pyright",
					-- "taplo",
					-- "texlab",
					-- "yamlls",
				},
			})
		end,
	},
}

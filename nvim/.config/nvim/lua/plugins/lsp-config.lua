return {
	"neovim/nvim-lspconfig",
	event = "BufRead *",
	dependencies = {
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
		{ "folke/neodev.nvim", opts = {} },
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require("lspconfig")
		lspconfig.bashls.setup({
			capabilities = capabilities,
		})
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})
		lspconfig.pyright.setup({
			capabilities = capabilities,
		})
		lspconfig.marksman.setup({
			capabilities = capabilities,
		})
		lspconfig.taplo.setup({
			capabilities = capabilities,
		})
		lspconfig.yamlls.setup({
			capabilities = capabilities,
		})
		-- keybindings
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show LSP description" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Show declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Show implementation" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
	end,
	---@class PluginLspOpts
	opts = {
		-- options for vim.diagnostic.config()
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
				-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
				-- prefix = "icons",
			},
			severity_sort = true,
		},
		-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
		-- Be aware that you also will need to properly configure your LSP server to
		-- provide the inlay hints.
		inlay_hints = {
			enabled = true,
		},
		-- add any global capabilities here
		capabilities = {},
		-- options for vim.lsp.buf.format
		-- `bufnr` and `filter` is handled by the LazyVim formatter,
		-- but can be also overridden when specified
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
	},
}

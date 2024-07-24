return {
	"folke/which-key.nvim",
	keys = { "<leader>" },
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		plugins = { spelling = true },
		defaults = {
			-- old mappings
			mode = { "n", "v" },
			["<leader>f"] = { name = "+find (Telescope)" },
			["<leader>t"] = { name = "+terminal" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+git hunks" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>w"] = { name = "+windows" },
			["<leader>c"] = { name = "+code" },
			["<leader>s"] = { name = "+Spectre" },
			["<leader>x"] = { name = "+Trouble" },
			["<leader>i"] = { name = "+Noice" },
		},
		-- new mappings?
		-- 	mode = { "n", "v" },
		-- 	{ "<leader>b", group = "buffer" },
		-- 	{ "<leader>c", group = "code" },
		-- 	{ "<leader>f", group = "find (Telescope)" },
		-- 	{ "<leader>g", group = "git" },
		-- 	{ "<leader>gh", group = "git hunks" },
		-- 	{ "<leader>i", group = "Noice" },
		-- 	{ "<leader>s", group = "Spectre" },
		-- 	{ "<leader>t", group = "terminal" },
		-- 	{ "<leader>w", group = "windows" },
		-- 	{ "<leader>x", group = "Trouble" },
		-- },
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}

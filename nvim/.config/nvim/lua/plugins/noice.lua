return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				-- TODO : fix override thowing erros in markdown docs
				-- ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				-- ["vim.lsp.util.stylize_markdown"] = true,
				-- ["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			-- lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		update_in_insert = false,
		routes = {
			{
				view = "split",
				filter = {
					min_width = 500,
					event = "msg_showmode",
					any = {
						{ find = "recording" },
					},
				},
			},
		},
	},
	keys = {
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Redirect Cmdline",
		},
		{
			"<leader>il",
			function()
				require("noice").cmd("last")
			end,
			desc = "Noice Last Message",
		},
		{
			"<leader>ih",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice History",
		},
		{
			"<leader>ia",
			function()
				require("noice").cmd("all")
			end,
			desc = "Noice All",
		},
		{
			"<leader>id",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
		{
			"<leader>ix",
			function()
				require("noice").cmd("disable")
			end,
			desc = "Disable Noice",
		},
		{
			"<leader>ie",
			function()
				require("noice").cmd("enable")
			end,
			desc = "Enable Noice",
		},

		{
			"<leader>it",
			function()
				require("noice").cmd("telescope")
			end,
			desc = "Noice Telescope",
		},
		{
			"<c-f>",
			function()
				if not require("noice.lsp").scroll(4) then
					return "<c-f>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Forward",
			mode = { "i", "n", "s" },
		},
		{
			"<c-b>",
			function()
				if not require("noice.lsp").scroll(-4) then
					return "<c-b>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Backward",
			mode = { "i", "n", "s" },
		},
	},
}

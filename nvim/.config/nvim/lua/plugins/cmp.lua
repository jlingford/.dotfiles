return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-buffer",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-path",
			event = "InsertEnter",
		},
		{
			"saadparwaiz1/cmp_luasnip",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-emoji",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-cmdline",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-nvim-lua",
		},
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()
		local icons = require("config.icons")
		return {
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<Right>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<A-CR>"] = cmp.mapping.complete(), -- see all autocomplete options while in insert mode
				-- ["<S-CR>"] = cmp.mapping.confirm({
				-- 	behavior = cmp.ConfirmBehavior.Replace,
				-- 	select = true,
				-- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "greek" },
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					vim_item.kind = icons.kind[vim_item.kind]
					vim_item.menu = ({
						nvim_lsp = "",
						nvim_lua = "",
						luasnip = "",
						buffer = "",
						path = "",
						emoji = "",
					})[entry.source.name]
					return vim_item
				end,
				max_width = 0,
			},
			source_names = {
				nvim_lsp = "(LSP)",
				emoji = "(Emoji)",
				path = "(Path)",
				calc = "(Calc)",
				cmp_tabnine = "(Tabnine)",
				vsnip = "(Snippet)",
				luasnip = "(Snippet)",
				buffer = "(Buffer)",
				tmux = "(TMUX)",
				copilot = "(Copilot)",
				treesitter = "(TreeSitter)",
			},
			duplicates = {
				buffer = 1,
				path = 1,
				nvim_lsp = 0,
				luasnip = 1,
			},
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
					col_offset = -3,
					side_padding = 1,
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
				},
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			sorting = defaults.sorting,
		}
	end,
	-- ---@param opts cmp.ConfigSchema
	-- config = function(_, opts)
	-- 	for _, source in ipairs(opts.sources) do
	-- 		source.group_index = source.group_index or 1
	-- 	end
	-- 	require("cmp").setup(opts)
	-- end,
}

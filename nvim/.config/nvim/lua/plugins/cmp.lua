return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-emoji" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-nvim-lua" },
        { "Saecki/crates.nvim" },
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
				["<C-Space>"] = cmp.mapping.complete(), -- see all autocomplete options while in insert mode
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
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "cmp_tabnine" },
				{ name = "greek" },
                { name = "crates" },
			},
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(entry, vim_item)
					vim_item.kind = icons.kind[vim_item.kind]
					vim_item.menu = ({
						nvim_lsp = "LSP",
						nvim_lua = "Lua",
						luasnip = "Snippet",
						buffer = "Buffer",
						path = "Path",
						emoji = "Emoji",
					})[entry.source.name]
					return vim_item
				end,
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
				nvim_lsp = 1,
				luasnip = 1,
			},
			window = {
				completion = {
					border = "",
					winhighlight = "Normal:CmpNormal,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
					col_offset = 0,
					side_padding = 1,
				},
				documentation = {
					border = "single",
					winhighlight = "Normal:CmpDocNormal,FloatBorder:FloatBorder,Search:None",
				},
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
                    native_menu = false,
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

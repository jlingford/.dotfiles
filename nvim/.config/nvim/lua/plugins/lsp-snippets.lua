return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}

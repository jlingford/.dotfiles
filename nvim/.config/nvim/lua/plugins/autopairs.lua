return {
	"windwp/nvim-autopairs",
	-- event = "InsertEnter",
	ft = { "lua", "rust" },
	config = function()
		require("nvim-autopairs").setup({})
	end,
}

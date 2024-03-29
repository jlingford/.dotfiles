return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	integrations = {
		neotree = true,
		telescope = { enabled = true },
	},
	config = function()
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}

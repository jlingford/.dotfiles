return {
	"nvim-treesitter/nvim-treesitter-context",
	-- enabled = true,
	-- ft = { "lua", "python", "rust", "bash" },
    -- TODO : treesitter-context throws a fit in markdown files. figure out how to fix
    -- currently making it so plugin is only active on :Context
    cmd = "Context",
	opts = { mode = "cursor", max_lines = 3 },
}

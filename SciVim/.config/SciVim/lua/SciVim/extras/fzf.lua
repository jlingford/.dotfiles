local map_fzf = function(mode, key, f, options, buffer)
	local desc = nil
	if type(options) == "table" then
		desc = options.desc
		options.desc = nil
	elseif type(options) == "function" then
		desc = options().desc
	end

	if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
		for _, k in ipairs({ "f", "l", "g" }) do
			key = key:gsub("<leader>" .. k, "<leader>" .. string.upper(k))
		end
		for _, k in ipairs({ "<F1>", "<c-P>", "<c-K>" }) do
			if key == k then
				key = "<leader>" .. k
			end
		end
		-- remap buffers
		if key == "<leader>," then
			key = "<leader>;"
		end
	end

	local rhs = function()
		local fzf_lua = require("fzf-lua")
		local custom = require("SciVim.extras.fzfcmds")
		-- use deepcopy so options ref isn't saved in the mapping
		-- as this can create weird issues, for example, `lgrep_curbuf`
		-- saving the filename in between executions
		if custom[f] then
			custom[f](options and vim.deepcopy(options) or {})
		else
			fzf_lua[f](options and vim.deepcopy(options) or {})
		end
	end

	local map_options = {
		silent = true,
		buffer = buffer,
		desc = desc or string.format("FzfLua %s", f),
	}

	vim.keymap.set(mode, key, rhs, map_options)
end

-- non "<leader>f" keys
map_fzf("n", "<leader>,", "buffers", { desc = "Fzf buffers" })
map_fzf("n", "<F1>", "help_tags", { desc = "help tags" })
map_fzf("n", "<leader>ff", "files", { desc = "find files" })
map_fzf("n", "<A-k>", "workdirs", {
	desc = "cwd workdirs",
	winopts = {
		height = 0.40,
		width = 0.60,
		row = 0.40,
	},
})

map_fzf("n", "<leader>fp", "files", {
	desc = "plugin files",
	prompt = "Plugins❯ ",
	cwd = vim.fn.stdpath("data") .. "/lazy",
})

-- only fzf
map_fzf("n", "<leader>fP", "profiles", { desc = "fzf-lua profiles" })
map_fzf("n", "<leader>f0", "tmux_buffers", { desc = "tmux paste buffers" })

-- same as tele
map_fzf("n", "<leader>f?", "builtin", { desc = "builtin commands" })
map_fzf("n", "<leader>fF", "resume", { desc = "resume" })
map_fzf("n", "<leader>fm", "marks", { desc = "marks" })
map_fzf("n", "<leader>fM", "man_pages", { desc = "man pages" })
map_fzf("n", "<leader>fx", "commands", { desc = "commands" })
map_fzf("n", "<leader>f:", "command_history", { desc = "command history" })
map_fzf("n", "<leader>f/", "search_history", { desc = "search history" })
map_fzf("n", "<leader>fy", "registers", { desc = "registers" })
map_fzf("n", "<leader>fk", "keymaps", { desc = "keymaps" })
map_fzf("n", "<leader>fz", "spell_suggest", {
	desc = "spell suggestions",
	-- prompt = "Spell> ",
	winopts = {
		title = " Spell ",
		relative = "cursor",
		row = 1.01,
		col = 0,
		height = 0.30,
		width = 0.30,
	},
})
map_fzf("n", "<leader>fT", "tags", { desc = "tags (project)" })
map_fzf("n", "<leader>ft", "btags", { desc = "tags (buffer)" })

map_fzf("n", "<leader>fr", "grep", { desc = "grep string (prompt)" })
map_fzf("n", "<leader>fR", "grep", { desc = "grep string resume", resume = true })
map_fzf("n", "<leader>fw", "grep_cword", { desc = "grep <word> (project)" })
map_fzf("n", "<leader>fW", "grep_cWORD", { desc = "grep <WORD> (project)" })
map_fzf("n", "<leader>fv", "grep_visual", { desc = "grep visual selection" })
map_fzf("v", "<leader>fv", "grep_visual", { desc = "grep visual selection" })
map_fzf("n", "<leader>fb", "blines", { desc = "fuzzy buffer lines" })
map_fzf("n", "<leader>fB", "lgrep_curbuf", { desc = "live grep (buffer)", prompt = "Buffer❯ " })
map_fzf("n", "<leader>fl", "live_grep", { desc = "live grep (project)" })
map_fzf("n", "<leader>fL", "live_grep", { desc = "live grep resume", resume = true })

map_fzf("n", "<leader>f3", "blines", function()
	return {
		desc = "blines <word>",
		fzf_opts = { ["--query"] = vim.fn.expand("<cword>") },
	}
end)
map_fzf("n", "<leader>f8", "grep_curbuf", function()
	return {
		desc = "grep <word> (buffer)",
		prompt = "Buffer❯ ",
		search = vim.fn.expand("<cword>"),
	}
end)
map_fzf("n", "<leader>f*", "grep_curbuf", function()
	return {
		desc = "grep <WORD> (buffer)",
		prompt = "Buffer❯ ",
		search = vim.fn.expand("<cWORD>"),
	}
end)
map_fzf("n", "<leader>fH", "oldfiles", { desc = "file history (all)" })
map_fzf("n", "<leader>fh", "oldfiles", function()
	return {
		desc = "file history (cwd)",
		cwd = vim.uv.cwd(),
		cwd_header = true,
		cwd_only = true,
	}
end)

map_fzf("n", "<leader>fq", "quickfix", { desc = "quickfix list" })
map_fzf("n", "<leader>fQ", "loclist", { desc = "location list" })
map_fzf("n", "<leader>fO", "highlights", { desc = "colorscheme highlights" })
map_fzf("n", "<leader>fo", "colorschemes", {
	desc = "colorschemes",
	winopts = { height = 0.45, width = 0.30 },
})

-- LSP
map_fzf("n", "<leader>ll", "lsp_finder", { desc = "location finder [LSP]" })
map_fzf("n", "<leader>lr", "lsp_references", { desc = "references [LSP]" })
map_fzf("n", "<leader>ld", "lsp_definitions", { desc = "definitions [LSP]", jump_to_single_result = false })
map_fzf("n", "<leader>lD", "lsp_declarations", { desc = "declarations [LSP]" })
map_fzf("n", "<leader>ly", "lsp_typedefs", { desc = "type definitions [LSP]" })
map_fzf("n", "<leader>lm", "lsp_implementations", { desc = "implementations [LSP]" })
map_fzf("n", "<leader>ls", "lsp_document_symbols", { desc = "document symbols [LSP]" })
map_fzf("n", "<leader>lS", "lsp_workspace_symbols", { desc = "workspace symbols [LSP]" })
map_fzf("n", "<leader>la", "lsp_code_actions", { desc = "code actions [LSP]" })
map_fzf("n", "<leader>lg", "diagnostics_document", { desc = "document diagnostics [LSP]" })
map_fzf("n", "<leader>lG", "diagnostics_workspace", { desc = "workspace diagnostics [LSP]" })

-- Git
map_fzf("n", "<leader>gf", "git_files", { desc = "git ls-files" })
map_fzf("n", "<leader>gs", "git_status", { desc = "git status" })
map_fzf("n", "<leader>gB", "git_branches", { desc = "git branches" })
map_fzf("n", "<leader>gt", "git_tags", { desc = "git tags" })
map_fzf("n", "<leader>gC", "git_commits", { desc = "git commits (project)" })
map_fzf({ "n", "v" }, "<leader>gc", "git_bcommits", { desc = "git commits (buffer)" })
-- Full screen git status
map_fzf("n", "<leader>gS", "git_status_tmuxZ", {
	desc = "git status (fullscreen)",
	winopts = {
		fullscreen = true,
		preview = {
			vertical = "down:70%",
			horizontal = "right:70%",
		},
	},
})

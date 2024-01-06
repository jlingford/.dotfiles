-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- useful options
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.ignorecase = true 	-- ignore case in search
vim.o.shiftwidth = 4 		-- size of indent
vim.o.smartindent = true 	-- inserts indents automatically
vim.o.wrap = false 		-- line wrap
vim.o.wildmode = 'longest,full'    -- command-line completion
vim.o.autoread = true 		-- vim knows what syntax the file is
vim.o.signcolumn = 'yes' 	-- column left of numbers to show errors
-- vim.o.textwidth = 120 		-- line length above which to break a line
vim.o.spell = true 		-- highlights spelling mistakes
vim.o.spelllang = 'en_gb' 	-- english spell check
vim.g.updatetime = 500		-- updates the swap file every X no. of milliseconds, important for gitgutter
vim.g.gitgutter_async = 0 	-- gitgutter auto-updates with every edit
vim.g.laststatus = 2 		-- always have statusline on
-- vim.o.splitbelow = true 	-- opens new window below
vim.o.splitright = true 	-- opens new window to the right, combined it will open new window vertically to the right
vim.o.termguicolors = true
-- vim.g.clipboard = unnamedplus   -- copy and paste between vim and all other programs

-- colour schemes
vim.cmd[[colorscheme tokyonight-night]]
--- MAPPINGS ---
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- switching colon and semicolon
vim.keymap.set('n', ';', ':', { noremap = true })	-- maps semicolon to colon 
vim.keymap.set('n', ':', ';', { noremap = true })	-- maps colon to semicolon 
vim.keymap.set('i', ';', ':', { noremap = true })	-- maps semicolon to colon 
vim.keymap.set('i', ':', ';', { noremap = true })	-- maps colon to semicolon 

-- autocomplete triangle brackets
vim.keymap.set('i', '<', '<><ESC>hli', {noremap = true})
vim.keymap.set('i', '`', '``<ESC>hli', {noremap = true})

-- moving lines and visual blocks of lines easily
vim.keymap.set('n', '<A-j>', '<cmd>m+<CR>==', { noremap = true })
vim.keymap.set('n', '<A-k>', '<cmd>m-2<CR>==', { noremap = true })
vim.keymap.set('v', '<A-j>', "<cmd>m<space>'>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', '<A-k>', "<cmd>m<space>'<-2<CR>gv=gv", { noremap = true })

-- Visual block mode, move blocks up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { noremap = true })

-- Movement around wrapped lines
vim.keymap.set('n', 'j', 'v:count ? "j" : "gj"', { noremap = true, expr = true, desc = 'Move down (including wrapping lines)' })
vim.keymap.set('n', 'k', 'v:count ? "k" : "gk"', { noremap = true, expr = true, desc = 'Move up (including wrapping lines)' })
vim.keymap.set('n', '<Up>', 'v:count ? "k" : "gk"', { noremap = true, expr = true, desc = 'Move up (including wrapping lines)' })
vim.keymap.set('n', '<Down>', 'v:count ? "j" : "gj"', { noremap = true, expr = true, desc = 'Move down (including wrapping lines)' })
vim.keymap.set('i', '<Up>', 'pumvisible() ? "k" : "<C-o>gk"', { noremap = true, expr = true, desc = 'Move up (including wrapping lines)' })
vim.keymap.set('i', '<Down>', 'pumvisible() ? "j" : "<C-o>gj"', { noremap = true, expr = true, desc = 'Move down (including wrapping lines)' })

-- ToggleTerm keymaps
vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<space>size=80<space>direction=vertical<CR>')
vim.keymap.set('n', '<leader>r', '<cmd>ToggleTermSendCurrentLine<CR>')
vim.keymap.set('v', '<leader>r', '<cmd>ToggleTermSendVisualSelection<CR>')

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Terminal vim.keymap.setpings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })




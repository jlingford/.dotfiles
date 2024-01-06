--- MAPPINGS ---
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- switching colon and semicolon
vim.keymap.set("n", ";", ":", { noremap = true }) -- maps semicolon to colon
vim.keymap.set("n", ":", ";", { noremap = true }) -- maps colon to semicolon
vim.keymap.set("i", ";", ":", { noremap = true }) -- maps semicolon to colon
vim.keymap.set("i", ":", ";", { noremap = true }) -- maps colon to semicolon

-- autocomplete brackets and quotes
vim.keymap.set("i", "(", "()<ESC>hli", { noremap = true })
vim.keymap.set("i", "{", "{}<ESC>hli", { noremap = true })
vim.keymap.set("i", "}", "{},<ESC>hhli", { noremap = true })
vim.keymap.set("i", "[", "[]<ESC>hli", { noremap = true })
vim.keymap.set("i", '"', '""<ESC>hli', { noremap = true })
vim.keymap.set("i", "'", "''<ESC>hli", { noremap = true })
vim.keymap.set("i", "<", "<><ESC>hli", { noremap = true })
vim.keymap.set("i", "`", "``<ESC>hli", { noremap = true })
vim.keymap.set("i", "*", "**<ESC>hli", { noremap = true })

-- moving lines and visual blocks of lines easily
vim.keymap.set("n", "<A-j>", "<cmd>m+<CR>==", { noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>m-2<CR>==", { noremap = true })
vim.keymap.set("v", "<A-j>", "<cmd>m<space>'>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<A-k>", "<cmd>m<space>'<-2<CR>gv=gv", { noremap = true })

-- Visual block mode, move blocks up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { noremap = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { noremap = true })

-- Movement around wrapped lines
vim.keymap.set(
	"n",
	"j",
	'v:count ? "j" : "gj"',
	{ noremap = true, expr = true, desc = "Move down (including wrapping lines)" }
)
vim.keymap.set(
	"n",
	"k",
	'v:count ? "k" : "gk"',
	{ noremap = true, expr = true, desc = "Move up (including wrapping lines)" }
)
vim.keymap.set(
	"n",
	"<Up>",
	'v:count ? "k" : "gk"',
	{ noremap = true, expr = true, desc = "Move up (including wrapping lines)" }
)
vim.keymap.set(
	"n",
	"<Down>",
	'v:count ? "j" : "gj"',
	{ noremap = true, expr = true, desc = "Move down (including wrapping lines)" }
)
vim.keymap.set(
	"i",
	"<Up>",
	'pumvisible() ? "k" : "<C-o>gk"',
	{ noremap = true, expr = true, desc = "Move up (including wrapping lines)" }
)
vim.keymap.set(
	"i",
	"<Down>",
	'pumvisible() ? "j" : "<C-o>gj"',
	{ noremap = true, expr = true, desc = "Move down (including wrapping lines)" }
)

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- neotree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Neotree" })

-- mason
vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- formatting
-- vim.keymap.set({ "n", "v" }, "<leader>cf", function()
--   Util.format({ force = true })
-- end, { desc = "Format" })

-- Terminal
vim.keymap.set("n", "<C-/>", "<cmd>ToggleTerm<CR>", { desc = "Open Terminal" })
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

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

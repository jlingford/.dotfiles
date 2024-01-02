-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
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

-- autocomplete triangle brackets
vim.keymap.set("i", "<", "<><ESC>hli", { noremap = true })
vim.keymap.set("i", "`", "``<ESC>hli", { noremap = true })

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

-- ToggleTerm keymaps
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<space>size=80<space>direction=vertical<CR>")
vim.keymap.set("n", "<leader>r", "<cmd>ToggleTermSendCurrentLine<CR>")
vim.keymap.set("v", "<leader>r", "<cmd>ToggleTermSendVisualSelection<CR>")

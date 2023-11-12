-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", ";", ":", { noremap = true }) -- maps semicolon to colon
vim.keymap.set("n", ":", ";", { noremap = true }) -- maps colon to semicolon
vim.keymap.set("i", ";", ":", { noremap = true }) -- maps semicolon to colon
vim.keymap.set("i", ":", ";", { noremap = true }) -- maps colon to semicolon

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

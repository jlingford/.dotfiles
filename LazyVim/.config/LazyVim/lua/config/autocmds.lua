-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- create ipynb filetype to lazy load on
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = "*.ipynb",
--   callback = function()
--     vim.bo.filetype = "ipynb"
--   end,
-- })

-- recognise ipynb as json
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "json"
    vim.b.notebook_file = true -- Custom flag for notebook files
  end,
})

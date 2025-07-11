return {
  "benlubas/molten-nvim",
  event = "VeryLazy",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  dependencies = { "3rd/image.nvim" },
  build = ":UpdateRemotePlugins",
  init = function()
    -- these are examples, not defaults. Please see the readme
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 100
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
  end,
  keys = {
    { "<leader>mi", ":MoltenInit<CR>", desc = "Molten: initialize" },
    { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Molten: evaluate operator", mode = "n" },
    { "<leader>mL", ":MoltenEvaluateLine<CR>", desc = "Molten: evaluate line" },
    -- { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" },
    { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Molten: evaluate visual selection", mode = "v" },
    { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Molten: hide output" },
    { "<leader>ms", ":MoltenShowOutput<CR>", desc = "Molten: show output" },
    { "<leader>md", ":MoltenDelete<CR>", desc = "Molten: delete cell" },
    { "<leader>mo", ":MoltenOpenInBrowser<CR>", desc = "Open in browser" },
    { "<leader>mI", ":MoltenImportOutput<CR>", desc = "Import output" },
    { "<leader>mE", ":MoltenExportOutput<CR>", desc = "Export output" },
    -- { "<leader>mS", ":MoltenSave<CR>", desc = "Save" },
    -- { "<leader>mL", ":MoltenLoad<CR>", desc = "Load" },
    -- { "<leader>mR", ":MoltenRestart<CR>", desc = "Restart kernel" },
    { "<leader>mx", ":MoltenDeinit<CR>", desc = "Molten: Deinitialize" },
  },
}

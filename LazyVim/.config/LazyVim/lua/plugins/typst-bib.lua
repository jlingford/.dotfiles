return {
  "Kirizan/typst-bib.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  ft = "typst",
  config = function()
    require("typst-bib").setup()
  end,
  -- Note: Keybindings should be set in your typst.lua config
  -- under <leader>kT to match your other Typst keybindings
}

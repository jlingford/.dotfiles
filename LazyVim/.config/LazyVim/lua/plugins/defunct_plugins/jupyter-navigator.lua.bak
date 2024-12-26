return {
  "GCBallesteros/NotebookNavigator.nvim",
  enabled = false,
  -- ft = ".ipynb",
  event = "VeryLazy",
  keys = {
    {
      "]h",
      function()
        require("notebook-navigator").move_cell("d")
      end,
    },
    {
      "[h",
      function()
        require("notebook-navigator").move_cell("u")
      end,
    },
    { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    { "<leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
  },
  dependencies = {
    "echasnovski/mini.comment",
    "hkupty/iron.nvim", -- repl provider
    -- "akinsho/toggleterm.nvim", -- alternative repl provider
    -- "benlubas/molten-nvim", -- alternative repl provider
    "anuvyklack/hydra.nvim",
  },
  config = function()
    local nn = require("notebook-navigator")
    nn.setup({ activate_hydra_keys = "<leader>h" })
  end,
}

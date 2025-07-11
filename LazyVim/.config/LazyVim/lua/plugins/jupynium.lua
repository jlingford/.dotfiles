return {
  "kiyoon/jupynium.nvim",
  build = "pip3 install --user .",
  event = "VeryLazy",
  -- build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
  -- build = "conda run --no-capture-output -n jupynium pip install .",
  -- "rcarriga/nvim-notify",   -- optional
  -- "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
  keys = {
    {
      "<leader>mj",
      ":JupyniumStartAndAttachToServer<cr>",
      desc = "Jupynium -> start & attach to server",
    },
    { "<leader>mJ", ":JupyniumStartSync<cr>", desc = "Jupynium -> start sync" },
  },
}

return {
  "SUSTech-data/neopyter",
  -- ft = { "*.ju.*" },
  cmd = "Neopyter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "AbaoFromCUG/websocket.nvim",
  },
  ---@type neopyter.Option
  opts = {
    mode = "direct",
    remote_address = "127.0.0.1:9001",
    file_pattern = { "*.ju.*" },
    on_attach = function(bufnr)
      -- do some buffer keymap
    end,
    highlight = {
      enable = true,
      shortsighted = false,
    },
    parser = {
      -- trim leading/tailing whitespace of cell
      trim_whitespace = false,
    },
  },
}

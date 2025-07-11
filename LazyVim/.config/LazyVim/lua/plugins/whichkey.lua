return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      -- molten/quarto keymaps and icons
      { "<leader>m", group = "+molten/quarto", icon = { icon = " ", color = "orange" } },
      { "<leader>mr", icon = { icon = " ", color = "cyan" } },
      { "<leader>ma", icon = { icon = " ", color = "cyan" } },
      { "<leader>mA", icon = { icon = " ", color = "cyan" } },
      { "<leader>ml", icon = { icon = " ", color = "cyan" } },
      { "<leader>mj", icon = { icon = "J ", color = "green" } },
      { "<leader>mJ", icon = { icon = "J ", color = "green" } },
      { "<leader>mq", group = "+quarto", icon = { icon = "󰏿 ", color = "cyan" } },
      { "<leader>m.", icon = { icon = "󰏿 ", color = "cyan" } },
      { "<leader>mp", icon = { icon = "󰏿 ", color = "cyan" } },
      -- toggleterm keymaps and icons
      { "<leader>t", group = "+toggleterm", icon = { icon = " ", color = "red" } },
    },
  },
}

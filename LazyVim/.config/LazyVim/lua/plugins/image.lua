return {
  "3rd/image.nvim",
  enabled = true,
  ft = { "markdown", "quarto" },
  -- event = "BufEnter",
  -- dependencies = { "leafo/magick" },
  opts = {
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        floating_windows = false,
        filetypes = { "markdown", "quarto" },
      },
    },
    tmux_show_only_in_active_window = true, -- prevents images from persisting when switching tmux panes
  },
}

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
    -- recommeded opts for using with molten.nvim
    backend = "kitty",
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "blink" }, -- ?
  },
}

return {
  {
    "rebelot/kanagawa.nvim",
    event = "VeryLazy",
  },
  {
    "mellow-theme/mellow.nvim",
    name = "mellow",
    event = "VeryLazy",
  },
  {
    "oxfist/night-owl.nvim",
    event = "VeryLazy",
  },
  {
    "fcancelinha/nordern.nvim",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "dgox16/oldworld.nvim",
    name = "oldworld",
    config = true,
    event = "VeryLazy",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VeryLazy",
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    event = "VeryLazy",
  },
  {
    "yorumicolors/yorumi.nvim",
    event = "VeryLazy",
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    name = "no-clown-fiesta",
    event = "VeryLazy",
  },
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    event = "VeryLazy",
  },
  {
    "philosofonusus/morta.nvim",
    name = "morta",
    event = "VeryLazy",
  },
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    event = "VeryLazy",
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    event = "VeryLazy",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      highlight_overrides = {
        all = function(colors)
          return {
            -- Make brackets red instead of grey
            ["@punctuation.bracket.python"] = { fg = colors.red },
            ["@function"] = { fg = colors.blue, style = {} },
            ["@function.method.call"] = { fg = colors.blue, style = {} },
            ["@variable.member"] = { fg = colors.lavender, style = { "italic" } },
            ["@variable.parameter"] = { fg = colors.maroon, style = { "italic" } },
          }
        end,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
  },
}

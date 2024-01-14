return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
            theme = "hyper",
			config = {
                header = {
                [[                                                                       ]],
                [[  ██████   █████                   █████   █████  ███                  ]],
                [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
                [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
                [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
                [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
                [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
                [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
                [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
                [[                                                                       ]],
                },
				center = {
                    -- {
                    --     icon = ' ',
                    --     icon_hl = 'Title',
                    --     desc = 'Find File           ',
                    --     desc_hl = 'String',
                    --     key = 'b',
                    --     keymap = 'SPC f f',
                    --     key_hl = 'Number',
                    --     key_format = ' %s', -- remove default surrounding `[]`
                    --     action = 'lua print(2)'
                    -- },
                    -- {
                    --     icon = ' ',
                    --     desc = 'Find Dotfiles',
                    --     key = 'f',
                    --     keymap = 'SPC f d',
                    --     key_format = ' %s', -- remove default surrounding `[]`
                    --     action = 'lua print(3)'
                    -- },
                    -- {
                        -- { action = "Telescope find_files", desc = " Find file",    icon = " ", key = "f" },
                        -- { action = "enew | startinsert",   desc = " New file",     icon = " ", key = "n" },
                        -- { action = "Telescope oldfiles",   desc = " Recent files", icon = " ", key = "r" },
                        -- { action = "Telescope live_grep",  desc = " Find text",    icon = " ", key = "g" },
                        -- { action = "qa",                   desc = " Quit",         icon = " ", key = "q" },
                    -- },
                },
				footer = {},
			},
		})
	end,
}

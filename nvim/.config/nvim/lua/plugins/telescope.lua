return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    lazy = true,
    cmd = "Telescope",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
        {  "nvim-telescope/telescope-ui-select.nvim", lazy = true },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '-u' -- thats the new thing
                },
            },
            pickers = {
                find_files = {
                    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
                },
                grep_string = {
                    additional_args = {'--hidden'}
                },
                live_grep = {
                    additional_args = {"--hidden"}
                },
            },
            extensions = {
                -- ui configuration
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({
                        -- opts go here
                    }),
                },
                -- bibtex.lua configuration
                bibtex = {
                    depth = 1,
                    custom_formats = {},
                    format = "",
                    global_files = {},
                    search_keys = { "author", "year", "title" },
                    citation_format = "{{author}}. {{year}}. {{title}}. *{{journal}}*.",
                    citation_trim_firstname = true,
                    citation_max_auth = 4,
                    context = false,
                    context_fallback = true,
                    wrap = false,
                },
            },
        })
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("bibtex")
    end,
}

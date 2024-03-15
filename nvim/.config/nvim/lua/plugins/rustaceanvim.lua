return {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
        server = {
            on_attach = function (_, bufnr)
                vim.keymap.set('n', '<leader>cR', function ()
                    vim.cmd.RustLsp("codeAction")
                end, { desc = "Code Action", buffer = bufnr })
                vim.keymap.set('n', '<leader>dr', function()
                    vim.cmd.RustLsp("debuggables")
                end, { desc = "Rust debuggables", buffer = bufnr })
            end,
            default_settings = {
                -- rust-analyzer lsp configuration
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        runBuildScripts = true,
                    },
                -- add clippy lints for Rust
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                    },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                        },
                    },
                },
            },
        },
    },
    config = function (_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local lsp = require("lspconfig")

        local on_attach = function(client, bufnr)
            vim.opt_local.formatexpr = "v:lua.vim.lsp.formatexpr()"

            -- format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lsp.pylsp.setup {
            capabilities = capabilities,
        }
        lsp.cssls.setup {
            capabilities = capabilities,
        }

        lsp.ts_ls.setup {
            capabilities = capabilities,
        }

        lsp.metals.setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        lsp.svelte.setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        lsp.rust_analyzer.setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        lsp.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }

        lsp.harper_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["harper-ls"] = {
                    userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
                }
            },
        }
    end,
}

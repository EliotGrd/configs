 return {
    {
        "neovim/nvim-lspconfig",
        ft = {"python", "c", "cpp", "lua", "go", "yaml"},
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function ()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            mason.setup()
            mason_lspconfig.setup {
                ensure_installed = {
                    "gopls",
                    "pylsp",
                    "lua_ls",
                    "clangd",
                    --"zls",
                    "yamlls",
                    --"ols",
                    -- "haskell-language-server",
                    -- "ocamllsp",
                },
            }
            local lspconfig = require("lspconfig")
            vim.diagnostic.config { signs = false, update_in_insert = false }
            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )
            -- $ go install golang.org/x/tools/gopls
            lspconfig.gopls.setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true
                    }
                }
            }
            -- from: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
            local go_import_callback = function()
                local wait_ms = 1000
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
                for _, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
                        else
                            vim.lsp.buf.execute_command(r.command)
                        end
                    end
                end
            end
            local augroup = vim.api.nvim_create_augroup("cacharle_gopls_group", {})
            vim.api.nvim_create_autocmd(
                "BufWritePre",
                { callback = go_import_callback, pattern = "*.go", group = augroup }
            )
            -- lspconfig.rust_analyzer.setup { on_attach = on_attach }
            -- need python-lsp-server and pyls-flake8
            lspconfig.pylsp.setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            flake8 = {
                                ignore = {"E501", "E221", "W503", "E241", "E402"},
                                maxLineLength = 100,
                            },
                        },
                    },
                },
            }
            -- package lua-language-server on ArchLinux
            lspconfig.lua_ls.setup {
                on_attach = on_attach ,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                            -- Setup your lua path
                            path = vim.split(package.path, ";"),
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {"vim", "use"},
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                            },
                        },
                    }
                },
            }
            -- brew install haskell-language-server
            --lspconfig.hls.setup { on_attach = on_attach }
            -- opam install ocaml-lsp-server
            --lspconfig.ocamllsp.setup { on_attach = on_attach }
            -- NOTE: to add compile arguments for standalone mode, create a .clangd file
            lspconfig.clangd.setup { on_attach = on_attach, cmd = {
                "clangd",
                "--header-insertion=never",
                "--pch-storage=memory",
                -- TODO: "--clang-tidy",
            } }
            -- pacman -S yaml-language-server
            lspconfig.yamlls.setup {
                settings = {
                    yaml = {
                        -- schemas = {
                        --     ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.17.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                        -- }
                        schemas = {
                            kubernetes = "*.yaml",
                            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                            -- ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                        },
                    }
                }
            }
            lspconfig.ols.setup{ on_attach = on_attach }
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        ft = {"rust"},
        config = function()
            -- require("rustaceanvim")
            -- to toggle inlay hints
            -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            vim.diagnostic.config { signs = false, update_in_insert = false }
            vim.g.rustfmt_autosave_if_config_present = 1
            -- vim.g.rustaceanvim.server.on_attach = function(_, bufnr)
            --     local opts = { noremap = true, silent = true }
            --     local map = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            --     map("n", "<leader>me", "<cmd>RustLsp expandMacro<CR>", opts)
            --     map("n", "<leader>d", "<cmd>RustLsp renderDiagnostic<CR>", opts)
            -- end
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind.nvim",
            "L3MON4D3/LuaSnip",
        },
        config = function ()
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup {
                mapping = cmp.mapping.preset.insert({
                    -- ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<Right>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        local has_words_before = function()
                          unpack = unpack or table.unpack
                          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                        end
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- order of the sources matter (first are higher priority)
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 2 },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                        menu = {
                            nvim_lsp = "[LSP]",
                            path = "[path]",
                            buffer = "[buf]",
                        }
                    })
                },
                window = { documentation = cmp.config.window.bordered(), },
                experimental = { ghost_text = true, },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                }
            }
        end
    }
 }

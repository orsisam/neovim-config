return {
    {
        "saghen/blink.cmp",
        version = "v1.*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("blink.cmp").setup({
                fuzzy = {
                    implementation = "prefer_rust", -- Menjamin performa pencarian super cepat via Rust
                },
                keymap = {
                    preset = "default",
                },
                completion = {
                    menu = {
                        auto_show = true,
                    },
                    documentation = {
                        auto_show = true,
                    },
                    ghost_text = {
                        enabled = false,
                        show_with_menu = false,
                    },
                    accept = {
                        auto_brackets = {
                            enabled = true, -- Otomatis menambahkan kurung () untuk fungsi PHP/JS
                        },
                    },
                },
                cmdline = {
                    enabled = true,
                    keymap = { preset = "cmdline" },
                    completion = {
                        menu = { auto_show = true },
                    },
                },
                sources = {
                    default = { "lsp", "path", "buffer", "snippets" },
                    -- Mengatur prioritas tmapilan autocomplete
                    min_keyword_length = 1,
                    providers = {
                        lsp = {
                            score_offset = 100, -- Utamakan hasil dari LSP (Intelphense, ts_ls, volar)
                            opts = {
                                tailwind_color_icon = "󱓻"
                            }
                        },
                        snippets = {
                            score_offset = 80, -- Prioritas kedua untuk snippet template kode
                        },
                        buffer = {
                            score_offset = 0, -- Kata dari teks biasa ditaruh paling bawah
                        },
                    }
                },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono",
                },
                snippets = {
                    preset = "luasnip"
                },
            })
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}

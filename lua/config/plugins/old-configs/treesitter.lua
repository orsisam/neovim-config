return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            -- Import nvim-treesitter plugin
            local treesitter = require("nvim-treesitter")

            -- ensure these languages parsers are installed
            local ensure_installed = {
                "json", "javascript", "typescript", "tsx", "go", "yaml", "html", "css",
                "http", "prisma", "markdown", "markdown_inline", "svelte", "graphql", "bash", "lua", "vim", "dockerfile",
                "gitignore", "query", "vimdoc", "c", "java", "rust", "php", "bash", "vue", "blade", "dart",
            }

            treesitter.install(ensure_installed)

            -- Safe FileType autocmd highlighting + indentation
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype
                    local lang = vim.treesitter.language.get_lang(ft)

                    if not lang then
                        return
                    end

                    -- load parder and start treesitter safely
                    pcall(vim.treesitter.language.add, lang)
                    pcall(vim.treesitter.start, buf, lang)

                    -- enable indentation (skip yaml/markdown)
                    if ft ~= "yaml" and ft ~= "markdown" then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.bo[buf].smartindent = false
                        vim.bo[buf].cindent = false
                    end
                end,
            })
        end,
    },

    -- NOTE: js, ts, jsx Auto close tags
    {
        "windwp/nvim-ts-autotag",
        enabled = true,
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", },
        config = function()
            -- Independent nvim-ts-autotagsetup
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,        -- Auto-close tags
                    enable_rename = true,       -- Auto-rename pairs
                    enable_close_on_slash = false -- Disable auto-close on triling `</`
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                    ["typescriptreact"] = {
                        enable_close = true,
                    },
                },
            })
        end,
    },
}

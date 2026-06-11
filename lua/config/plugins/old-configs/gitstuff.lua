return {
    {
        "tpope/vim-fugitive",
        config = function()
            local keymap = vim.keymap.set
            keymap("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Figitive fullscreen tab", })

            local myFugitive = vim.api.nvim_create_augroup("myFugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = myFugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = {buffer = bufnr, remap = false}

                    keymap("n", "<leader>P", function() vim.cmd.Git('push') end, opts)

                    -- NOTE: rebase always
                    keymap("n", "<leader>p", function() vim.cmd.Git({'pull', '--rebase'}) end, opts)

                    -- NOTE: easy setup branch that  wasn't setup properly
                    keymap("n", "<leader>t", ":Git push -u origin ", opts)
                end,
            })
        end,
    },
    
    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Navigation
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")

                -- Actions
                map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
                map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")

                map("v", "<leader>gs", function() -- stage selected hunk
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk in Visula Mode")
                map("v", "<leader>gr", function() -- reset selected hunk
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk in Visula Mode")

                map("n", "<leader>gS", gs.stage_buffer, "Stage buffer") -- stage whole buffer
                map("n", "<leader>gR", gs.reset_buffer, "Reset buffer") -- unstage whole buffer
                map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>gbl", function() gs.blame_line({ full = true }) end, "Slame line")
                map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
                map("n", "<leader>gd", gs.diffthis, "Diff this")
                map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this ~")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Giysigns select_hunk<cr>", "Gitsigns select hunk")
            end,
        },
    },

    -- Lazy git
    {
        "kedheepak/lazygit.nvim", 
        -- NOTE: Trying out lazygit in Snacks nvim
        enabled = false,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile", 
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- window border thing
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting up with keys={} allows plugin to laod when command runs at the start
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open Lazy git" }
        },
    },

    -- git worktree
    {
        "ThePrimeagen/git-worktree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },

        config = function()
            local gitworktree = require("git-worktree")

            gitworktree.setup()

            require("telescope").load_extension("git_worktree")

            -- HACK: by default
            -- <Enter> - Switches to that worktree
            -- <c-d> - deletes that worktree
            -- <c-f> - toggles forcing of the next deletion

            -- Create new worktree
            vim.keymap.set("n", "<leader>wl", function()
                require("telescope").extensions.git_worktree.git_worktrees()
            end, { desc = "list Git Worktrees" })

            -- Switch/list worktree
            vim.keymap.set("n", "<leader>wc", function()
                require("telescope").extensions.git_worktree.create_git_worktree()
            end, { desc = "Create Git Worktree Branches" })
        end,
    }
}

return {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- Optional: to create UI for choose emulator
        "saghen/blink.cmp",
    },
    config = function ()
        -- Ambil capabilities dari blink.cmp agar autocomplete Flutter super kencang
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("blink-cmp").get_lsp_capabilities(capabilities)

        require("flutter-tools").setup({
            lsp = {
                capabilities = capabilities,
                -- Menggunakan otomasi LSPAttach yang sudah dibuat fi lspconfig.lua
                -- agar semua keymaps (gd, gR, K, dll) otomatis aktif di file Dart
                color_factor = 0.1,
                settings = {
                    showTodos = true,
                    completeFunctionCalls = true,
                    animationProgress = true,
                },
            },
            debugger = {
                enabled = false,
            },
            widget_guides = {
                enabled = true, -- Menampilkan garis bantu struktur widget Flutter (Sangat membantu)
            },
            closing_tags = {
                highlight = "Comment",
                prefix = " // ",
                enabled = true, -- Menampilkan teks penutup widget otomatis di ujung kanan baris
            },
            dev_log = {
                enabled = true,
                notify_errors = false,
                open_cmd = "vsplit", -- Membuka log Flutter di jendela split vertikal saat aplikasi jalan
            },
        })

        -- ===================================================================================== 
        -- USER COMMAND FOR RUNNING FLUTTER BASH SCRIPT
        -- =====================================================================================
        vim.api.nvim_create_user_command("FlutterNew", function(opts)
            local project_name = opts.args

            if project_name == "" then
                vim.notify("Error: Project name can't be empty!", vim.log.levels.ERROR)
                return
            end

            local clean_name = string.lower(project_name):gsub("-", "_")
            -- Getting absolute path of current active directory
            local current_dir = vim.fn.getcwd()
            local full_project_path = current_dir .. "/" .. clean_name

            vim.notify(full_project_path)
            -- vim.notify("Executing script...", vim.log.levels.INFO)

            local error_output = {}

            -- Running bash script asynchronously
            vim.fn.jobstart({ "/home/" .. vim.uv.os_getenv("USER") .. "/scripts/flutter-new.sh", project_name }, {
                stdout_buffered = true,
                stderr_buffered = true,
                on_exit = function(_, exit_code, _)
                    if exit_code == 0 then
                        -- 1. Move Neovim working directory to new project
                        -- vim.cmd("cd " .. full_project_path)

                        -- 2. Waiting 100ms to let Neovim asynchronousing new folder before open dart file
                        -- vim.defer_fn(function()

                        vim.schedule(function()
                            vim.cmd("cd " .. full_project_path)
                            -- Open file main.dart using absolute path
                            local main_dart_path = full_project_path .. "/lib/main.dart"
                            vim.cmd("edit " .. main_dart_path)

                            -- Ask oil.nvim to refreshing
                            pcall(function() require("oil").refresh() end)

                            vim.notify("Project successfully created! Happy coding.", vim.log.levels.INFO)
                        end)
                    else
                        local err_msg = table.concat(error_output, "\n")
                        if err_msg == "" then err_msg = "Unknown error (Exit code: " .. exit_code .. ")" end

                        vim.notify("Gagal \n" .. err_msg, vim.log.levels.ERROR)
                    end
                end,
            }) -- end vim.fn.jobstart()
        end, {
                nargs = 1,
                desc = "Create Flutter project using external command inside nvim."
            })
        -- ===================================================================================== 
        -- end of user command
        -- =====================================================================================

        -- ===================================================================================== 
        -- USER COMMAND TO REMOVE ALL COMMENTS ON FLUTTER TEMPLATE
        -- =====================================================================================
        vim.api.nvim_create_user_command("FlutterCleanComments", function()
            -- 1. Save cursor current position in order not jump while clean up
            local save_cursor = vim.fn.getpos(".")

            -- 2. Run Regex subtitution on all file (%)
            -- using pcall (protected call) in order no error appears while everything is clean
            pcall(function()
                -- Menghapus semua baris murni (// ...) termasuk spasi di depannya
                vim.cmd([[%s/\s*\/\/.*$//ge]])

                -- Menghapus baris-baris kosong beruntun yang ditingalkan oleh bekas komentar
                -- agar struktur kode menjadi rapi
                vim.cmd([[g/^\s*$/d]])
            end)

            -- 3. Kembalikan posisi kursor ke tempat semula
            vim.fn.setpos(".", save_cursor)

            -- 4. Jalankan auto-format LSP (jika aktif) agar indentation kembali rapi
            vim.lsp.buf.format({ async = true })

            vim.notify("Komentar berhasil dihapus.", vim.log.levels.INFO)
        end, {
                desc = "Erase all comment on main.dart",
            })

        -- Custom Keymaps untuk kebutuhan Flutter workflow
        local opts = { silent = true }
        opts.desc = "Flutter Run / Start App"
        vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<cr>", opts)

        opts.desc = "Flutter Hot Reload"
        vim.keymap.set("n", "<leader>fo", "<cmd>FlutterReload<cr>", opts)

        opts.desc = "Flutter Hot Restart"
        vim.keymap.set("n", "<leader>fR", "<cmd>FlutterRestart<CR>", opts)

        opts.desc = "Flutter Quit / Stop App"
        vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", opts)

        opts.desc = "Flutter Devices / Select Emulator"
        vim.keymap.set("n", "<leader>fd", "<cmd>FlutterDevices<CR>", opts)
    end,
}

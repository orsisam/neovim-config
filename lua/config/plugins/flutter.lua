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
        vim.api.nvim_create_user_command("FlutterNew", function (opts)
            local project_name = opts.args

            if project_name == "" then
                vim.notify("Error: Project name cannot be empty!", vim.log.levels.ERROR)
                return
            end

            -- Running Bash Script asynchronously to prevent freeze
            vim.fn.jobstart({ "/home/" .. vim.uv.os_getenv("USER") .. "/scripts/flutter-new.sh", project_name  }, {
                stdout_buffered = true,
                stderr_buffered = true,
                on_exit = function (_, exit_code, _)
                    if exit_code == 0 then
                        -- Karena di dalam Bash Script ada perintah 'cd', kita sinkronisasikan
                        -- Neovim agar otomatis ikut masuk ke folder project baru tersebut.
                        local clean_name = string.lower(project_name):gsub("-", "_")
                        vim.cmd("cd " .. clean_name)
                        vim.cmd("edit lib/main.dart")
                        vim.notify("Project sukses dibuat dan dimuat!", vim.log.levels.INFO)
                    else
                        vim.notify("Gagal mengeksekusi script flutter-new.sh", vim.log.levels.ERROR)
                    end
                end,
            })
        end,{
                nargs = 1,
                desc = "Membuat Project Flutter baru dengan menjalankan perintah bash script",
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

return {
    "akinsho/toggleterm.nvim",
    enabled = false,
    version = "*",
    config = function()
        require("toggleterm").setup({
            -- Mengatur ukuran adaptif berdasarkan arah split jendela
            size = function(term)
                if term.direction == "horizontal" then
                    return vim.o.lines * 0.4 -- Jendela bawah mengambil 40% tinggi layar
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4 -- Jendela kanan/kiri mengambil 30% lebar layar
                end
            end,
            hide_numbers = true,        -- Menyembunyikan nomor baris di terminal
            shade_terminals = true,     -- Memberikan sedikit efek gelap pada terminal pasif
            persist_size = true,        -- Mengingat ukuran jendela jika di-resize manual
            close_on_exit = true,       -- Otomatis tutup window saat proses shell selesai
            shell = vim.o.shell,        -- Menggunakan shell bawaan OS
            -- Mengatur gaya visual untuk terminal melayang (float)
            float_opts = {
                border = "curved",      -- Bentuk pinggiran melayang (single, double, curved)
                winblend = 3,           -- Efek sedikit transparan
            },
        })

        -- ==============================================================
        -- KEYMAPS UNTUK MEMBUAK TERMINAL (Normal Mode)
        -- ==============================================================
        local keymap = vim.keymap.set

        -- 1. Buka di BAWAH (horizontal)
        keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal: Bawah" })
        
        -- 2. Buka di KANAN (Vertical)
        keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal: Kanan" })
        
        -- 3. Buka MELAYANG (Float di tengah layar)
        keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal: Float" })

        -- 4. Buka di TAB BARU Neovim
        keymap("n", "<leader>tt", "<cmd>ToggelTerm direction=tab<cr>", { desc = "Terminal: Tab Baru" })


        -- ==============================================================
        -- SINKRONISASI NAVIGASI DENGAN VIM-TMUX-NAVIGATOR (Terminal Mode)
        -- ==============================================================
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }

            -- Mode Normal Terminal: Tekan 'jk' atau 'Esc' untuk bisa menggulung/scroll teks terminal
            keymap("t", "<esc>", [[<C-\><C-n>]], opts)
            keymap("t", "jk", [[<C-\><C-n>]], opts)

            -- Pindah panel secara mulus menggunakan Ctrl + h/j/k/l langsung dari dalam terminal
            keymap("t", "<C-h>", [[<Cmd>TmuxNavigatorLeft<CR>]], opts)
            keymap("t", "<C-j>", [[<Cmd>TmuxNavigatorDown<CR>]], opts)
            keymap("t", "<C-k>", [[<Cmd>TmuxNavigatorUp<CR>]], opts)
            keymap("t", "<C-l>", [[<Cmd>TmuxNavigatorRight<CR>]], opts)
        end

        -- Daftarkan fungsi navigasi di atas agar otomatis aktif setiap kali ToggleTerm dibuka
        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end
}

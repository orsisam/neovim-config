-- This is where plugins installed because no need more 
-- configurations

return {
    "nvim-lua/plenary.nvim", -- multiple plugins need
    "christoomey/vim-tmux-navigator", -- tmux & split window nav
    -- fixes undefined globals
    {
        "folke/lazydev.nvim",
        lazy = "VeryLazy",
        priority = 1000,
        opts = {
            library = {
                {
                    path = "${3rd}/plenary.nvim/lua",
                    words = { "plenary" }
                },
                { path = "Lazyvim" },
            },
        },
    },
}

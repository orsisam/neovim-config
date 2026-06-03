return {
    "aserowy/tmux.nvim",
    config = function()
        require("tmux").setup({
            copy_sync = {
                -- Activate clipboard sync between Neonim, Tmux, and Ubuntu
                enable = true,
            },
            navigation = {
                -- Activate navigation using Ctrl + h/j/k/l between tmux and split  window
                enable_default_keybindings = true,
            },
            resize = {
                enable_default_keybindings = true,
            },
        })
    end,
}

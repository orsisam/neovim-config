vim.cmd("let g:netrw_banner = 0")

-- vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.wrap = false

-- backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- search
-- vim.opt.incsearch = true
vim.opt.inccommand = "split"
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true

-- UI
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- folding
vim.o.foldenable = true
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldcolumn = "0"

-- window splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- misc
vim.opt.guicursor = ""
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "0"
vim.opt.clipboard:append("unnamedplus")
vim.opt.mouse = "a"

-- Highlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end
})

-- vim.opt.termguicolors = true
-- vim.opt.background = "dark"
-- vim.opt.scrolloff = 8
-- vim.opt.signcolumn = "yes"
--
vim.opt.backspace = {"start", "eol", "indent"}
--
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
--
-- vim.opt.isfname:append("@-@")
-- vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "80"
--
-- vim.opt.clipboard:append("unnamedplus")
vim.opt.hlsearch = true
--
-- vim.opt.mouse = "a"
vim.g.editorconfig = true

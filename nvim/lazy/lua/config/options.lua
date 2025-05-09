-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable break indent
vim.o.breakindent = true

-- No swap file
vim.o.swapfile = false
vim.o.backup = false

-- Save undo history
vim.o.undodir = os.getenv("HOME") .. "/.vim/undo"
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Tab width
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Always print at least 4 lines
vim.o.scrolloff = 4

-- List chars
vim.opt.listchars:append({ eol = "↵", tab = " ⇢", trail = "·" })
vim.o.list = false

-- Decreate update time
vim.o.updatetime = 250

-- minimap
vim.g.neominimap = { auto_enable = false }

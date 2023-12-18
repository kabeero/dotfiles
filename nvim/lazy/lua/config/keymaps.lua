-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local builtin = require("telescope.builtin")

-- Dvorak navigation
vim.keymap.set({ "n", "v" }, ",", "j", { desc = "Move down" })
vim.keymap.set({ "n", "v" }, ".", "k", { desc = "Move up" })

-- Dvorak find jump
-- vim.keymap.set("n", "j", ",", { desc = "Find previous occurrence" })
-- vim.keymap.set("n", "k", ";", { desc = "Find next occurrence" })
-- vim.keymap.set("v", "j", ",", { desc = "Find previous occurrence" })
-- vim.keymap.set("v", "k", ";", { desc = "Find next occurrence" })

-- Create tab
-- vim.keymap.set({ "n", "v" }, "<leader>t", vim.cmd.tabnew, { desc = "Create new tab" })
-- vim.keymap.set("n", "<C-c>", "<C-h>:BufferLineCloseRight<Return>", { desc = "Close pane" })

-- Move to window using the <shift> hjkl keys
vim.keymap.set("n", "H", "<C-w>W", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "J", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "K", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "L", "<C-w>w", { desc = "Go to right window", remap = true })

-- Buffer movements
vim.keymap.set("n", "<C-h>", vim.cmd.bprevious, { desc = "Go to left buffer", remap = true })
vim.keymap.set("n", "<C-l>", vim.cmd.bnext, { desc = "Go to right buffer", remap = true })
vim.keymap.set("n", "<C-c>", vim.cmd.bd, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>t", vim.cmd.enew, { desc = "Create buffer" })

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Yank to system clipboard
-- vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
-- vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" }) -- selection
-- vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to system clipboard" }) -- whole line

-- Centered half-page navigation
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Centered text search
vim.keymap.set("n", "n", "nzzzv", { desc = "Go to next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to prev search result (centered)" })

-- Toggle scroll offset
vim.keymap.set("n", "zT", function()
  vim.o.scrolloff = (vim.o.scrolloff + 8) % 16
end, { desc = "Toggle scroll offset" })

-- NvimTree
-- replaced with Neotree
-- vim.keymap.set({ "n", "v" }, "<leader>,", vim.cmd.NvimTreeToggle, { desc = "NvimTree toggle" })

-- Toggle wordwrap
vim.keymap.set("n", "<leader>W", function()
  vim.o.wrap = not vim.o.wrap
  print("Wordwrap " .. (vim.o.wrap and "enabled" or "disabled"))
end, { desc = "Toggle word wrap" })

-- Toggle expandtab
vim.keymap.set("n", "<leader><tab>", function()
  vim.o.expandtab = not vim.o.expandtab
  print("Tab expansion " .. (vim.o.expandtab and "enabled" or "disabled"))
end, { desc = "Toggle tab expansion" })

-- Toggle list (display unprintable characters)
vim.keymap.set("n", "<leader>.", function()
  vim.o.list = not vim.o.list
  print("Invisible characters " .. (vim.o.list and "enabled" or "disabled"))
end, { desc = "Toggle hidden characters" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>#", function()
  vim.o.relativenumber = not vim.o.relativenumber
  print("Relative line numbers " .. (vim.o.relativenumber and "enabled" or "disabled"))
end, { desc = "Toggle relative line numbers" })

-- Toggle tab expansion
vim.keymap.set("n", "<leader>$", function()
  vim.o.expandtab = not vim.o.expandtab
  if vim.o.expandtab == true then
    print("Tab expansion enabled")
  else
    print("Tab expansion disabled")
  end
end, { desc = "Toggle tab expansion" })

-- Rotate theme
vim.keymap.set("n", "<leader>i", builtin.colorscheme, { desc = "Select Colorscheme" })
vim.keymap.set("n", "<leader>I", function()
  if vim.colorscheme == nil or vim.colorscheme == "light" then
    vim.colorscheme = "storm"
    vim.cmd([[colorscheme tokyonight-storm]])
  elseif vim.colorscheme == "storm" then
    vim.colorscheme = "moon"
    vim.cmd([[colorscheme tokyonight-moon]])
  elseif vim.colorscheme == "moon" then
    vim.colorscheme = "night"
    vim.cmd([[colorscheme tokyonight-night]])
  elseif vim.colorscheme == "night" then
    vim.colorscheme = "gotham"
    vim.cmd([[colorscheme gotham]])
  elseif vim.colorscheme == "gotham" then
    vim.colorscheme = "catppuccin"
    vim.cmd([[colorscheme catppuccin]])
  elseif vim.colorscheme == "catppuccin" then
    vim.colorscheme = "monet"
    vim.cmd([[colorscheme monet]])
  elseif vim.colorscheme == "monet" then
    vim.colorscheme = "light"
    vim.cmd([[colorscheme tokyonight-day]])
  end
  print("Colorscheme: " .. vim.colorscheme)
end, { desc = "Rotate Colorscheme" })

-- GitUI
vim.keymap.set("n", "<leader>gu", function()
  Util.terminal({ "gitui" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = "GitUI (root dir)" })
vim.keymap.set("n", "<leader>gU", function()
  Util.terminal({ "gitui" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "GitUI (cwd)" })

-- Neogit
vim.keymap.set("n", "<leader>gg", vim.cmd.Neogit, { desc = "Neogit" })
vim.keymap.set("n", "<leader>gG", function()
  vim.cmd.Neogit({ args = { "cwd=" .. Util.root() } })
end, { desc = "Neogit (root)" })

-- Git status
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

-- Toggle blame
vim.keymap.set("n", "<leader>gb", vim.cmd.GitBlameToggle, { desc = "Git blame toggle" })
local git_blame = require("gitblame")
git_blame.disable()

-- Toggle trouble
vim.keymap.set("n", "<leader>Tt", vim.cmd.TroubleToggle, { desc = "Trouble toggle" })

-- Ranger
vim.keymap.set("n", "<leader>fg", function()
  Util.terminal({ "ranger", Util.root() }, { esc_esc = false, ctrl_hjkl = false, size = { width = 0.7, height = 0.7 } })
end, { desc = "Ranger (project)" })

vim.keymap.set("n", "<leader>fG", function()
  Util.terminal(
    { "ranger", vim.uv.os_homedir() },
    { esc_esc = false, ctrl_hjkl = false, size = { width = 0.7, height = 0.7 } }
  )
end, { desc = "Ranger (~)" })

-- jless
vim.keymap.set("n", "<leader>fj", function()
  local name = vim.api.nvim_buf_get_name(0)
  Util.terminal(
    { "jless", "-r", "-m", "line", name },
    { esc_esc = false, ctrl_hjkl = false, size = { width = 1.0, height = 1.0 } }
  )
end, { desc = "jless (line)" })
vim.keymap.set("n", "<leader>fJ", function()
  local name = vim.api.nvim_buf_get_name(0)
  Util.terminal(
    { "jless", "-r", "-m", "data", name },
    { esc_esc = false, ctrl_hjkl = false, size = { width = 1.0, height = 1.0 } }
  )
end, { desc = "jless (data)" })

-- lnav
vim.keymap.set("n", "<leader>fl", function()
  -- local name = string.gsub(vim.api.nvim_buf_get_name(0), vim.uv.cwd(), "")
  local name = vim.api.nvim_buf_get_name(0)
  Util.terminal({ "lnav", name }, { esc_esc = false, ctrl_hjkl = false, size = { width = 1.0, height = 1.0 } })
end, { desc = "lnav" })

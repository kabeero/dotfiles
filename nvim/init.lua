-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use {
    -- Useful status updates for LSP
    'j-hui/fidget.nvim',
    tag = 'legacy'
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Highlight words and lines on the cursor
  -- use 'yamatsum/nvim-cursorline'
  use 'RRethy/vim-illuminate'

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'kevinhwang91/rnvimr'

  -- Trouble browser
  use {
    'folke/trouble.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- File outline
  use 'preservim/tagbar'
  use 'simrat39/symbols-outline.nvim'

  -- Tab bar
  -- use 'fgheng/winbar.nvim'
  use 'Bekaboo/dropbar.nvim'

  -- Tab styling
  use 'romgrk/barbar.nvim'

  -- Scrollbar
  use 'petertriho/nvim-scrollbar'
  use 'folke/tokyonight.nvim'

  -- Color picker 
  use 'ziontee113/color-picker.nvim'

  -- Practice vim
  use 'ThePrimeagen/vim-be-good'

  -- webdev icons
  use 'nvim-tree/nvim-web-devicons'

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'f-person/git-blame.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-symbols.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Go
  use 'ray-x/go.nvim'

  -- Copilot
  -- use 'github/copilot.vim'
  use 'Exafunction/codeium.vim'

  -- Aesthetic
  use 'folke/twilight.nvim' -- Dims inactive portions of code
  use 'folke/zen-mode.nvim' -- Float buffer for focus

  -- Rainbow CSV
  use {
    'cameron-wags/rainbow_csv.nvim',
    config = function()
        require 'rainbow_csv'.setup()
    end,
    -- optional lazy-loading below
    module = {
        'rainbow_csv',
        'rainbow_csv.fns'
    },
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    }
  }

  -- Glow
  use {'ellisonleao/glow.nvim', config = function() require('glow').setup() end}

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

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

-- Always print at least 8 lines
vim.o.scrolloff = 8

-- List chars
vim.opt.listchars:append({ eol = '↵', tab = ' ⇢', trail = '·' })

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd[[colorscheme tokyonight-night]]
-- vim.cmd[[colorscheme onedark]]

-- Transparent background
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Makes * and # work on visual mode too.
vim.cmd([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]])

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Toggle wordwrap
vim.keymap.set('n', '<leader>W', function()
    vim.o.wrap = not vim.o.wrap
    print("Wordwrap " .. (vim.o.wrap and "enabled" or "disabled"))
end, { desc = 'Toggle hidden characters' })

-- Toggle expandtab
vim.keymap.set('n', '<leader><tab>', function()
    vim.o.expandtab = not vim.o.expandtab
    print("Tab expansion " .. (vim.o.expandtab and "enabled" or "disabled"))
end, { desc = 'Toggle tab expansion' })

-- Toggle list (display unprintable characters)
vim.keymap.set('n', '<leader>.', function()
    vim.o.list = not vim.o.list
    print("Invisible characters " .. (vim.o.list and "enabled" or "disabled"))
end, { desc = 'Toggle hidden characters' })

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>#', function()
    vim.o.relativenumber = not vim.o.relativenumber
    print("Relative line numbers " .. (vim.o.relativenumber and "enabled" or "disabled"))
end, { desc = 'Toggle relative line numbers' })

-- Toggle tab expansion
vim.keymap.set('n', '<leader>$', function()
  vim.o.expandtab = not vim.o.expandtab
  if vim.o.expandtab == true then
    print 'Tab expansion enabled'
  else
    print 'Tab expansion disabled'
  end
end, { desc = 'Toggle tab expansion' })

-- Dvorak navigation
vim.keymap.set('n', ',', 'j', { desc = 'Move down' })
vim.keymap.set('v', ',', 'j', { desc = 'Move down (visual)' })
vim.keymap.set('n', '.', 'k', { desc = 'Move up' })
vim.keymap.set('v', '.', 'k', { desc = 'Move up (visual)' })

-- Dvorak find jump
vim.keymap.set('n', 'j', ',', { desc = 'Find previous occurrence' })
vim.keymap.set('n', 'k', ';', { desc = 'Find next occurrence' })
vim.keymap.set('v', 'j', ',', { desc = 'Find previous occurrence' })
vim.keymap.set('v', 'k', ';', { desc = 'Find next occurrence' })

-- Pane navigation
vim.keymap.set('n', '<C-c>', '<C-w>c', { desc = 'Close pane' })
vim.keymap.set('n', '<C-h>', 'gT', { desc = 'Cycle pane left' })
vim.keymap.set('n', '<C-l>', 'gt', { desc = 'Cycle pane right' })
vim.keymap.set('n', 'H', '<C-w>W', { desc = 'Cycle tab left' })
vim.keymap.set('n', 'L', '<C-w>w', { desc = 'Cycle tab right' })

-- Centered half-page navigation
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up, centered' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down, centered' })

-- Tabs
vim.keymap.set('n', '<leader>t', vim.cmd.tabnew, { desc = 'Create new [t]ab' })

-- Buffers
vim.keymap.set('n', '<leader>n', vim.cmd.bnext, { desc = '[N]ext buffer' })
vim.keymap.set('n', '<leader>N', vim.cmd.bprev, { desc = 'Prev buffer' })

-- Paste without losing buffer
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = 'Paste without losing buffer' })

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = 'Yank to system clipboard' })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = 'Yank to system clipboard' }) -- selection
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = 'Yank to system clipboard' }) -- whole line

-- Paste from system clipboard
vim.keymap.set("n", "<leader>cp", "o<esc>\"+p", { desc = 'Paste from system clipboard' })
vim.keymap.set("v", "<leader>cp", "o<esc>\"+p", { desc = 'Paste from system clipboard' }) -- paste inline
vim.keymap.set("n", "<leader>cP", "O<esc>\"+P", { desc = 'Paste from system clipboard' }) -- paste above

-- Indent selection
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })

-- Move lines (more)
-- vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
-- vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
-- vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
-- vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = 'Join lines and keep cursor position' })

-- Centered text search
vim.keymap.set("n", "n", "nzzzv", { desc = 'Go to next search result (centered)' })
vim.keymap.set("n", "N", "Nzzzv", { desc = 'Go to prev search result (centered)' })

-- Toggle scroll offset
vim.keymap.set("n", "zT", function()
    vim.o.scrolloff = (vim.o.scrolloff + 8) % 16
end, { desc = 'Toggle scroll offset' })

-- Quickfix list navigation
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = 'Quickfix navigate next' })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = 'Quickfix navigate prev' })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = 'Quickfix navigate next' })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = 'Quickfix navigate prev' })

-- Replace text under cursor
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = 'Replace hovered word' })
vim.keymap.set("v", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = 'Replace highlighted word' })
vim.keymap.set("n", "<leader>x", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = 'Replace highlighted word' })

-- Telescope symbols
vim.keymap.set("n", "<leader>ps", "<cmd>Telescope symbols<cr>", { desc = 'Telescope Symbols' })
vim.keymap.set("i", "<leader>ps", "<cmd>Telescope symbols<cr>", { desc = 'Telescop Symbols' })

-- Color picker
local opts = { desc = 'Color Picker', noremap = true, silent = true }
vim.keymap.set("n", "<leader>pc", "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", "<leader>pc", "<cmd>PickColorInsert<cr>", opts)

-- GUID Create
vim.keymap.set("n", "<leader>cu", function()
  local number = math.random(math.pow(2, 127) + 1, math.pow(2, 128))
  return "i" .. string.format("%.0f", number)
end, {
  expr = true,
  desc = "GUID",
})

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Save in insert mode
vim.keymap.set("i", "<C-s>", "<cmd>:w<cr><esc>")
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr><esc>")
-- vim.keymap.set("n", "<C-c>", "<cmd>normal ciw<cr>a")

-- Setup plugins
require("nvim-tree").setup({
  sort_by = "case_insensitive",
  view = {
    adaptive_size = true,
    -- mappings = {
    --   list = {
    --     { key = "u", action = "dir_up" },
    --   },
    -- },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    -- toggle with H
    dotfiles = true,
  },
})
vim.keymap.set('n', '<leader>,', vim.cmd.NvimTreeToggle, { desc = 'NvimTree toggle' })


-- Ranger file browser
-- require("rnvimr").setup({
--     rnvimr_enable_ex = 1,
--     rnvimr_enable_picker = 1,
--     rnvimr_edit_cmd = 'drop',
--     rnvimr_draw_border = 1,
--     rnvimr_hide_gitignore = 0,
-- })
vim.keymap.set('n', '<leader>r', vim.cmd.RnvimrToggle, { desc = 'Ranger toggle' })

require("symbols-outline").setup()

require("color-picker").setup({
    ["icons"] = { "ﱢ", "" },
    ["border"] = "rounded", -- none | single | double | rounded | solid | shadow
    ["keymap"] = {
        ["H"] = "<Plug>ColorPickerSlider5Decrease",
        ["L"] = "<Plug>ColorPickerSlider5Increase",
    },
    ["background_highlight_group"] = "Normal",
    ["border_highlight_group"] = "FloatBorder",
  ["text_highlight_group"] = "Normal",
})
vim.cmd([[hi FloatBorder guibg=NONE]]) -- if you don't want weird border background colors around the popup.

local colors = require("tokyonight.colors").setup()
require("scrollbar").setup({
  handle = {
      color = colors.bg_highlight,
  },
  marks = {
      Search = { color = colors.orange },
      Error = { color = colors.error },
      Warn = { color = colors.warning },
      Info = { color = colors.info },
      Hint = { color = colors.hint },
      Misc = { color = colors.purple },
  }
})

-- require('winbar').setup({
--     enabled = true,
--     show_file_path = true,
--     show_symbols = true,
--
--     colors = {
--         path = '', -- You can customize colors like #c946fd
--         file_name = '',
--         symbols = '',
--     },
--
--     icons = {
--         file_icon_default = '',
--         seperator = '>',
--         editor_state = '●',
--         lock_icon = '',
--     },
--
--     exclude_filetype = {
--         'help',
--         'startify',
--         'dashboard',
--         'packer',
--         'neogitstatus',
--         'NvimTree',
--         'Trouble',
--         'alpha',
--         'lir',
--         'Outline',
--         'spectre_panel',
--         'toggleterm',
--         'qf',
--     }
-- })
require('barbar').setup()

-- Toggle Twilight
require('twilight').setup({ context = 30 })
vim.keymap.set('n', '<leader>ht', vim.cmd.Twilight, { desc = 'Toggle Twilight' })

-- Toggle ZenMode
require('zen-mode').setup({ plugins = { twilight = { enabled = false }, kitty = { enabled = true} } })
vim.keymap.set('n', '<leader>hz', vim.cmd.ZenMode, { desc = 'Toggle ZenMode' })

-- Toggle Glow
vim.keymap.set('n', '<leader>hg', vim.cmd.Glow, { desc = 'Toggle Glow' })

-- Git status
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })

-- Toggle blame
vim.keymap.set('n', '<leader>b', vim.cmd.GitBlameToggle, { desc = 'Git blame toggle' })
local git_blame = require('gitblame')
git_blame.disable()

-- Toggle trouble
vim.keymap.set('n', '<leader>Tt', vim.cmd.TroubleToggle, { desc = 'Trouble toggle' })

-- Toggle diagnostics
local diagnostics_active = true
vim.keymap.set('n', '<leader>Ts',
    function()
        diagnostics_active = not diagnostics_active
        if diagnostics_active then
            vim.diagnostic.show()
        else
            vim.diagnostic.hide()
        end
        print("Diagnostics: " .. tostring(diagnostics_active))
    end,
    { desc = 'Show trouble messages' }
)

-- Toggle tagbar
vim.keymap.set('n', '<leader>\'',
    function()
        if (vim.outline_mode == nil or vim.outline_mode == 'none') then
            vim.outline_mode = 'symbols'
            vim.cmd.SymbolsOutlineOpen()
        elseif (vim.outline_mode == 'symbols') then
            vim.outline_mode = 'tagbar'
            vim.cmd.SymbolsOutlineClose()
            vim.cmd.TagbarOpen()
        elseif (vim.outline_mode == 'tagbar') then
            vim.outline_mode = 'none'
            vim.cmd.TagbarClose()
        end
    end
    ,
    { desc = 'Symbols outline toggle' }
)
vim.keymap.set('n', '<leader>\"',
    function()
        if (vim.outline_mode == nil or vim.outline_mode == 'none') then
            return
        elseif (vim.outline_mode == 'symbols') then
            vim.cmd.SymbolsOutlineClose()
        elseif (vim.outline_mode == 'tagbar') then
            vim.cmd.TagbarClose()
        end
        vim.outline_mode = 'none'
    end
    ,
    { desc = 'Close symbols outline' }
)

-- Rotate theme
vim.keymap.set('n', '<leader>I',
    function()
        if (vim.colorscheme == nil or vim.colorscheme == 'light') then
            vim.colorscheme = 'storm'
            vim.cmd[[colorscheme tokyonight-storm]]
        elseif (vim.colorscheme == 'storm') then
            vim.colorscheme = 'moon'
            vim.cmd[[colorscheme tokyonight-moon]]
        elseif (vim.colorscheme == 'moon') then
            vim.colorscheme = 'night'
            vim.cmd[[colorscheme tokyonight-night]]
        elseif (vim.colorscheme == 'night') then
            vim.colorscheme = 'light'
            vim.cmd[[colorscheme tokyonight-day]]
        end
        print("Colorscheme: " .. vim.colorscheme)
    end,
    { desc = 'Rotate theme colors' }
)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    -- theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Go autofmt on save
require('go').setup()
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash', 'c', 'cpp', 'css', 'go', 'eex', 'elixir', 'heex', 'html', 'javascript', 'lua', 'python', 'rust', 'scss', 'typescript', 'help'
  },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      node_decremental = '<c-backspace>',
      scope_incremental = '<c-s>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

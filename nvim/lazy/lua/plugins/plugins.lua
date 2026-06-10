return {
  { "akinsho/bufferline.nvim" },
  { "catppuccin/nvim", lazy = false },
  { "nvim-mini/mini.pairs", enabled = false },
  { "edeneast/nightfox.nvim", lazy = false },
  {
    "Exafunction/codeium.nvim",
    lazy = true,
    opts = {
      enterprise_mode = true,
      api = { host = "enterprise-url.com", path = "/_route/api_server" },
    },
    enabled = false,
  },
  { "f-person/auto-dark-mode.nvim", lazy = false, opts = {} },
  { "f-person/git-blame.nvim" },
  { "folke/tokyonight.nvim", lazy = false },
  { "fynnfluegge/monet.nvim", lazy = false },
  {
    "ibhagwan/fzf-lua",
    keys = { { "<leader>fg", false } },
    opts = function(_, opts)
      -- Find Files
      opts.files = opts.files or {}
      opts.files.fd_opts = "--color=never --type f --hidden --follow --no-ignore --exclude .git"
      opts.files.rg_opts = "--color=never --files --hidden --follow --no-ignore -g '!.git'"

      -- Live Grep
      opts.grep = opts.grep or {}
      opts.grep.rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --no-ignore -e"
    end,
  },
  { "Isrothy/neominimap.nvim" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      aliases = { ["b"] = false },
      surrounds = {
        ["$"] = { add = { "${", "}" }, find = "$%b{}", delete = "^(..)().-(.)()$" },
        ["b"] = { add = { "**", "**" }, find = "%*%*.-%*%*", delete = "^(%*%*?)().-(%*%*?)()$" },
      },
    },
  },
  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" }, config = true },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = true,
  },
  { "nvim-neo-tree/neo-tree.nvim", opts = { window = { position = "float" } } },
  { "nvim-telescope/telescope-symbols.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--no-ignore",
        "--hidden",
      }
      opts.pickers = opts.pickers or {}
      opts.pickers.live_grep = opts.pickers.live_grep or {}
      opts.pickers.live_grep.additional_args = function()
        return { "--no-ignore", "--hidden" }
      end
      opts.pickers.find_files = opts.pickers.find_files or {}
      opts.pickers.find_files.hidden = true
      opts.pickers.find_files.no_ignore = true
    end,
  },
  { "nvim-tree/nvim-tree.lua", enabled = false },
  { "s1n7ax/nvim-window-picker" },
  { "tpope/vim-fugitive" },
  { "whatyouhide/vim-gotham", lazy = false },
  { "xiyaowong/transparent.nvim", lazy = false },
}

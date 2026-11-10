return {
  { "akinsho/bufferline.nvim" },
  { "catppuccin/nvim", lazy = false },
  { "edeneast/nightfox.nvim", lazy = false },
  { "f-person/auto-dark-mode.nvim", lazy = false, opts = {} },
  { "folke/tokyonight.nvim", lazy = false },
  { "fynnfluegge/monet.nvim", lazy = false },
  {
    "Isrothy/neominimap.nvim",
    init = function()
      vim.g.neominimap = { auto_enable = false }
    end,
  },
  { "nvim-neo-tree/neo-tree.nvim", opts = { window = { position = "float" } } },
  { "nvim-tree/nvim-tree.lua", enabled = false },
  { "s1n7ax/nvim-window-picker" },
  { "whatyouhide/vim-gotham", lazy = false },
  { "xiyaowong/transparent.nvim", lazy = false },
}

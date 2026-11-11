return {
  { "f-person/git-blame.nvim" },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "esmuellert/codediff.nvim" },
    opts = { diff_viewer = "codediff" },
    config = true,
  },
  { "tpope/vim-fugitive" },
}

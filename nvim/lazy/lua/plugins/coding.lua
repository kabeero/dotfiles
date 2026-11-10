return {
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "Exafunction/codeium.nvim",
    lazy = true,
    opts = {
      enterprise_mode = true,
      api = { host = "enterprise-url.com", path = "/_route/api_server" },
    },
    enabled = false,
  },
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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- upstream lspconfig ships oxfmt with toml/json/yaml in its filetypes,
        -- so mason-lspconfig auto-attached it to every pyproject.toml buffer.
        -- Disable it here; formatting stays with conform/prettier.
        oxfmt = { enabled = false },
      },
    },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = true,
  },
  { "olimorris/codecompanion.nvim", lazy = false },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*",
    cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteLog" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
      { "<leader>rs", "<cmd>RemoteStart<cr>", desc = "Remote Start" },
      { "<leader>ro", "<cmd>RemoteStop<cr>", desc = "Remote Stop" },
      { "<leader>ri", "<cmd>RemoteInfo<cr>", desc = "Remote Info" },
      { "<leader>rc", "<cmd>RemoteCleanup<cr>", desc = "Remote Cleanup" },
      { "<leader>rl", "<cmd>RemoteLog<cr>", desc = "Remote Log" },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>r", group = "remote" },
      },
    },
  },
}

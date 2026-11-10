return {
  {
    "ibhagwan/fzf-lua",
    keys = { { "<leader>fg", false } },
    opts = function(_, opts)
      -- Find Files
      opts.files = opts.files or {}
      opts.files.fd_opts =
        "--color=never --type f --hidden --follow --no-ignore --exclude .git --exclude .venv --exclude .delta"
      opts.files.rg_opts = "--color=never --files  --hidden --follow --no-ignore -g '!.git' -g '!.venv' -g '!.delta'"

      -- Live Grep
      opts.grep = opts.grep or {}
      opts.grep.rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --no-ignore -g '!.venv' -g '!.delta' -e"
    end,
  },
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
}

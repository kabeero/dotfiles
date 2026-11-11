return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          -- Replace nvim-lint's default args ({ "-" }, stdin mode) with an
          -- explicit --config. This is the BASE config layer, not a
          -- replacement: markdownlint-cli2 still discovers repo-level
          -- .markdownlint* files and merges them ON TOP of the base, so
          -- repo configs stay authoritative for every rule they mention
          -- (verified against markdownlint-cli2 v0.24.0). MD013
          -- (line-length) is off by default here: long lines are
          -- intentional in markdown docs; a repo config can re-enable it.
          -- Note: stdin-mode config discovery walks up from nvim's cwd
          -- (LazyVim's rooter chdirs to the project root), not the file's
          -- directory.
          args = { "--config", vim.fn.stdpath("config") .. "/etc/markdownlint-cli2.jsonc", "-" },
        },
      },
    },
  },
}

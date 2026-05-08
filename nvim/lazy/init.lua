-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("telescope").setup({
  pickers = {
    live_grep = {
      additional_args = function(opts)
        return { "--no-ignore" }
      end,
    },
  },
})

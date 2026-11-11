-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Buffer garbage-collector ---------------------------------------------------
-- 1. fzf-lua's builtin previewer creates listed buffers for every previewed file.
-- 2. LSP workspace indexing (e.g. marksman) and pickers can register hundreds
--    of unlisted named buffer shells (buflisted=0).
-- Both accumulate diagnostic caches and plugin state, ballooning LuaJIT heap
-- and causing severe GC lag.
-- Periodically prune both listed buffers (when over cap) and ghost unlisted file buffers.
local MAX_LISTED_BUFFERS = 150

local function trim_buffers(max_listed)
  -- Keep current buffer and anything visible in any window across all tabpages.
  local keep = { [vim.api.nvim_get_current_buf()] = true }
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
    if ok then
      keep[buf] = true
    end
  end

  local function is_safe_to_delete(b)
    return not keep[b]
      and vim.api.nvim_buf_is_valid(b)
      and vim.api.nvim_get_option_value("buftype", { buf = b }) == ""
      and not vim.api.nvim_get_option_value("modified", { buf = b })
  end

  local deleted = 0

  -- Pass 1: Prune unlisted named file buffers (LSP/picker scan ghosts)
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_get_option_value("buflisted", { buf = b }) then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= "" and is_safe_to_delete(b) then
        if pcall(vim.api.nvim_buf_delete, b, { force = true }) then
          deleted = deleted + 1
        end
      end
    end
  end

  -- Pass 2: Prune listed buffers if above cap
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed >= max_listed then
    for _, info in ipairs(listed) do
      local b = info.bufnr
      if is_safe_to_delete(b) then
        if pcall(vim.api.nvim_buf_delete, b, { force = false }) then
          deleted = deleted + 1
        end
      end
    end
  end

  if deleted > 50 then
    collectgarbage("collect")
  end
end

-- Timer 1 (Initial warmup sweep):
-- Wait 30s after startup before running the first cleanup. This avoids doing
-- buffer deletions while plugins and LSPs are still initializing on launch.
vim.defer_fn(function()
  trim_buffers(MAX_LISTED_BUFFERS)
end, 30000)

-- Timer 2 (Recurring background sweep):
-- Runs every 60s (starting 60s after launch) via libuv background timer.
-- Silently prunes preview overflow from fzf-lua searches and unlisted ghost
-- buffers left behind by LSP workspace scans (e.g. marksman indexing markdown files).
local trim_timer = vim.uv.new_timer()
trim_timer:start(60000, 60000, function()
  trim_buffers(MAX_LISTED_BUFFERS)
end)

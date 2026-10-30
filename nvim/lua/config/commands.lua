vim.api.nvim_create_user_command("PerformanceStats", function()
  local stats = {
    "=== Performance Stats ===",
    "Buffer lines: " .. vim.api.nvim_buf_line_count(0),
    "Loaded buffers: " .. #vim.fn.getbufinfo({ buflisted = 1 }),
    "LSP clients: " .. #vim.lsp.get_clients(),
    "Treesitter active: " .. tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil),
  }
  vim.notify(table.concat(stats, "\n"), vim.log.levels.INFO)
end, { desc = "Show performance stats" })

-- Show diagnostics inline for the current line only, until toggled off again
vim.keymap.set("n", "<leader>xv", function()
  local on = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = on and { current_line = true } or false })
end, { desc = "Toggle inline diagnostics" })

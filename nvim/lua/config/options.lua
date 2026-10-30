vim.opt.updatetime = 100
vim.opt.timeoutlen = 300
vim.opt.redrawtime = 10000

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.colorcolumn = "100"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.history = 1000
vim.opt.winborder = "rounded"

-- Native folding (treesitter where a parser exists); everything starts unfolded
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Experimental in 0.12: redesigned messages/cmdline, no "Press ENTER" prompts
pcall(function() require("vim._core.ui2").enable({}) end)

-- Setting the clipboard provider is slow on macOS; defer it past startup
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Diagnostics live in the sign column and underlines; details on demand
-- (<C-w>d for the line, ]d/[d to jump, <leader>xv to toggle inline)
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  underline = true,
  signs = true,
  severity_sort = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Keep the lockfile next to the real (symlinked) config so it is versioned in dotfiles
local config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config") .. "/init.lua"), ":h")

require("lazy").setup({ { import = "plugins" } }, {
  lockfile = config_dir .. "/lazy-lock.json",
  -- Every plugin must declare how it loads (event/cmd/keys/ft) or set lazy = false
  defaults = { lazy = true },
  -- Show available updates in :Lazy, but only update when asked
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})

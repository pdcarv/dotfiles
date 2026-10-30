-- Personal Neovim configuration
-- Languages: Go, Python, Rust, Scala, SQL, Nix, Lua

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.lazy")

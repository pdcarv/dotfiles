-- Install packer.nvim first:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
--   ~/.local/share/nvim/site/pack/packer/start/packer.nvim

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'scalameta/nvim-metals',
    requires = {
      'nvim-lua/plenary.nvim',
    },
  }

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- File explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons'
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Status line
  use 'nvim-lualine/lualine.nvim'

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Colorscheme
  use { 'ellisonleao/gruvbox.nvim', priority = 1000 }

  -- Testing
  use 'vim-test/vim-test'
  use 'mfussenegger/nvim-dap'
end)

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300

-- Colorscheme configuration
require("gruvbox").setup({
  contrast = "hard", -- can be "hard", "soft" or empty string
  transparent_mode = false,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
})
vim.cmd("colorscheme gruvbox")

-- Key mappings
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>')

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'gopls',           -- Go
    'rust_analyzer',   -- Rust
    'jdtls',          -- Java
    'pyright',        -- Python
    'solargraph',     -- Ruby
    'bashls',         -- Shell scripts
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP server configurations
local lspconfig = require('lspconfig')

-- Go
lspconfig.gopls.setup{
  capabilities = capabilities,
}

-- Rust
lspconfig.rust_analyzer.setup{
  capabilities = capabilities,
}

-- Scala (Metals setup)
local metals_config = require("metals").bare_config()
metals_config.capabilities = capabilities

-- Metals specific settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {},
  serverVersion = "latest.snapshot",
}

-- Debug settings if you're using nvim-dap
metals_config.init_options.statusBarProvider = "on"

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- Java
lspconfig.jdtls.setup{
  capabilities = capabilities,
}

-- Python
lspconfig.pyright.setup{
  capabilities = capabilities,
}

-- Ruby
lspconfig.solargraph.setup{
  capabilities = capabilities,
}

-- Shell
lspconfig.bashls.setup{
  capabilities = capabilities,
}

-- Autocompletion setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'go', 'rust', 'scala', 'java', 'python', 'ruby', 'bash',
    'lua', 'vim', 'regex', 'markdown', 'yaml',
  },
  highlight = {
    enable = true,
  },
})

-- File explorer configuration
require('nvim-tree').setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
})

-- Status line configuration
require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
})

-- Git signs configuration
require('gitsigns').setup()

-- Testing configuration
vim.g['test#strategy'] = 'neovim'
vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>')
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')

-- Debug Adapter Protocol setup
local dap = require('dap')

-- Configure debuggers for different languages here
-- Example for Go:
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = 'delve',
    name = 'Debug',
    request = 'launch',
    program = '${file}'
  },
}

-- Debug keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dc', dap.continue)
vim.keymap.set('n', '<leader>dn', dap.step_over)
vim.keymap.set('n', '<leader>di', dap.step_into)
vim.keymap.set('n', '<leader>do', dap.step_out)

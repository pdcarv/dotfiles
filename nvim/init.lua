-----------------------------------------------------------
-- Completion and Snippet Configuration
-----------------------------------------------------------

-- Initialize completion
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Configure completion
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', vim_item.kind, vim_item.kind) -- This concatenates the icons with the name of the item kind
      
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        path = "[Path]",
      })[entry.source.name]
      
      return vim_item
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer', keyword_length = 3 },
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true, -- Show future text in gray
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' }
  })
})

-- Configure snippets
luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [require('luasnip.util.types').choiceNode] = {
      active = {
        virt_text = {{"●", "GruvboxOrange"}}
      }
    }
  }
})

-- Go snippets
luasnip.add_snippets("go", {
  luasnip.snippet("iferr", {
    luasnip.text_node({"if err != nil {", "\t"}),
    luasnip.insert_node(1, "return err"),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("fn", {
    luasnip.text_node("func "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node("("),
    luasnip.insert_node(2),
    luasnip.text_node(") "),
    luasnip.insert_node(3),
    luasnip.text_node({" {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("st", {
    luasnip.text_node("type "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node({" struct {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("test", {
    luasnip.text_node("func Test"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node("(t *testing.T) {"),
    luasnip.text_node({"", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  -- More advanced test snippet with table-driven tests
  luasnip.snippet("tabtest", {
    luasnip.text_node("func Test"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node({"(t *testing.T) {", "\ttests := []struct {", "\t\tname string", "\t\t"}),
    luasnip.insert_node(2, "input type"),
    luasnip.text_node({"", "\t\twant "}),
    luasnip.insert_node(3, "type"),
    luasnip.text_node({"\t}{", "\t\t{", "\t\t\tname: \""}),
    luasnip.insert_node(4, "test case"),
    luasnip.text_node("\","),
    luasnip.insert_node(0),
    luasnip.text_node({"\t\t},", "\t}", "", "\tfor _, tt := range tests {", "\t\tt.Run(tt.name, func(t *testing.T) {", "\t\t\t// Test implementation", "\t\t})", "\t}", "}"})
  }),

  -- Error type definition
  luasnip.snippet("errtype", {
    luasnip.text_node("type "),
    luasnip.insert_node(1, "ErrorType"),
    luasnip.text_node({" struct {", "\tmsg string", "}", "", "func (e *"}),
    luasnip.insert_node(1),
    luasnip.text_node({") Error() string {", "\treturn e.msg", "}"}),
  }),

  -- Context-aware function
  luasnip.snippet("ctxfn", {
    luasnip.text_node("func "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node("(ctx context.Context, "),
    luasnip.insert_node(2, "params"),
    luasnip.text_node(") "),
    luasnip.insert_node(3, "error"),
    luasnip.text_node({" {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),
})-- Basic setup
local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
  return
end

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  }
})-- This is a comprehensive Neovim configuration file with special attention to Go development
-- It's structured in sections: plugins, basic settings, plugin configurations, and language-specific setups
-- The Go-specific configuration uses gopls as the primary driver for formatting and import management

-----------------------------------------------------------
-- Initial Setup and Plugin Management
-----------------------------------------------------------

-- First ensure packer is installed:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
--   ~/.local/share/nvim/site/pack/packer/start/packer.nvim

vim.cmd [[packadd packer.nvim]]

-- Create autocommand groups at the top level to ensure they're available globally
local format_group = vim.api.nvim_create_augroup("Format", { clear = true })
local go_group = vim.api.nvim_create_augroup("Go", { clear = true })

-- Initialize go.nvim configuration globally before any modules are loaded
-- This prevents the '_GO_NVIM_CFG' nil error by ensuring the config exists
vim.g.go_nvim_config = {
  goimport = 'gopls',        -- Use gopls for import management
  gofmt = 'gofumpt',        -- Standardized Go formatting
  max_line_len = 120,
  tag_transform = false,
  test_template = '',
  test_template_dir = '',
  comment_placeholder = '',
  verbose = false,
  lsp_cfg = false,          -- We'll handle LSP setup separately for better control
  lsp_gofumpt = true,
  lsp_codelens = true,
  diagnostic = {
    hdlr = true,
    underline = true,
    virtual_text = { space = 0, prefix = '■' },
    signs = true,
  }
}

-----------------------------------------------------------
-- Plugin Declarations
-----------------------------------------------------------

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'
  
  -- Auto-pairs for bracket completion
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" },
        enable_check_bracket_line = true,
        check_ts = true,  -- Use treesitter to check for pairs
        ts_config = {
          lua = {'string'},  -- Don't add pairs in lua string treesitter nodes
          javascript = {'template_string'},
          java = false,  -- Don't check treesitter on java
        }
      })
    end
  }

  -- LSP and completion
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'scalameta/nvim-metals',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Completion framework and sources
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- File navigation and search
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  -- Code analysis and highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- UI enhancements
  use 'nvim-lualine/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  use { 'ellisonleao/gruvbox.nvim', priority = 1000 }

  -- Testing and debugging
  use 'vim-test/vim-test'
  use 'mfussenegger/nvim-dap'
  use 'nvim-neotest/nvim-nio'
  use {
    "rcarriga/nvim-dap-ui",
    requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
  }

  -- Go development - notice the config function that properly initializes go.nvim
  use {
    'ray-x/go.nvim',
    requires = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup(vim.g.go_nvim_config)
    end
  }

  -- Auto-pairs for bracket completion
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" },
        enable_check_bracket_line = true,
        check_ts = true,  -- Use treesitter to check for pairs
        ts_config = {
          lua = {'string'},  -- Don't add pairs in lua string treesitter nodes
          javascript = {'template_string'},
          java = false,  -- Don't check treesitter on java
        }
      })

      -- Make autopairs and completion work together
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  }

  -- Additional tools
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons"
  }
  use {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup()
    end
  }
end)

-----------------------------------------------------------
-- General Settings
-----------------------------------------------------------

-- Basic editor configuration
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300

-- Create an autocommand group for filetype-specific settings
local filetype_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

-- Set up Go-specific indentation (8 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    -- In Go, we want to use tabs with a width of 8 spaces
    vim.bo.expandtab = false      -- Use actual tabs instead of spaces
    vim.bo.tabstop = 8           -- Display tabs as 8 spaces wide
    vim.bo.shiftwidth = 8        -- Use 8 spaces when indenting with '>'
    vim.bo.softtabstop = 8       -- Backspace deletes 8 spaces at a time
  end,
  group = filetype_group,
})

-- Theme setup
require("gruvbox").setup({
  contrast = "hard",
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

-----------------------------------------------------------
-- LSP Configuration
-----------------------------------------------------------

-- Initialize completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Set up Mason for LSP installer management
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'gopls',           -- Go
    'rust_analyzer',   -- Rust
    'jdtls',          -- Java
    'pyright',        -- Python
    'bashls',         -- Shell
  },
  automatic_installation = false
})

-- LSP server configurations
local lspconfig = require('lspconfig')

-- Go LSP setup with integrated formatting
lspconfig.gopls.setup{
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = true,
    },
  },
  -- Attach additional functionality when LSP connects
  on_attach = function(client, bufnr)
    -- Ensure formatting is enabled
    client.server_capabilities.documentFormattingProvider = true
    
    -- Buffer-local keymaps for Go-specific features
    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<leader>gi', '<cmd>GoImport<CR>', opts)
    vim.keymap.set('n', '<leader>gf', '<cmd>GoFormat<CR>', opts)
    vim.keymap.set('n', '<leader>gt', '<cmd>GoTest<CR>', opts)
    vim.keymap.set('n', '<leader>gr', '<cmd>GoRun<CR>', opts)
  end,
}

-- Set up Go file formatting using gopls
-- We split this into two autocmds: one for formatting and one for imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Format the buffer using gopls
    vim.lsp.buf.format({ 
      async = false,
      timeout_ms = 5000
    })
  end,
  group = format_group,
})

-- Separate autocmd for organizing imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Get the gopls client
    local active_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    local client = nil
    for _, c in ipairs(active_clients) do
      if c.name == "gopls" then
        client = c
        break
      end
    end
    
    if not client then
      return
    end

    -- Prepare parameters for import organization
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    
    -- Send synchronous request to organize imports
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 5000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          -- Apply the edit with the client's offset encoding
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        elseif r.command then
          -- If we receive a command instead of an edit, execute it
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
  group = go_group,
})

-- Set up Go file formatting using gopls
-- We split this into two autocmds: one for formatting and one for imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Format the buffer using gopls
    vim.lsp.buf.format({ 
      async = false,
      timeout_ms = 5000
    })
  end,
  group = format_group,
})

-- Separate autocmd for organizing imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Prepare parameters for import organization
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    
    -- Send synchronous request to organize imports
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          -- Remove explicit encoding parameter which was causing issues
          vim.lsp.util.apply_workspace_edit(r.edit)
        end
      end
    end
  end,
  group = go_group,
})

-- [Rest of your LSP configurations for other languages remain the same...]

-----------------------------------------------------------
-- Plugin Configurations
-----------------------------------------------------------

-----------------------------------------------------------
-- Completion and Snippet Configuration
-----------------------------------------------------------

-- Initialize completion
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Configure completion
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
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
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

-- Configure snippets
luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

-- Go snippets
luasnip.add_snippets("go", {
  luasnip.snippet("iferr", {
    luasnip.text_node({"if err != nil {", "\t"}),
    luasnip.insert_node(1, "return err"),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("fn", {
    luasnip.text_node("func "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node("("),
    luasnip.insert_node(2),
    luasnip.text_node(") "),
    luasnip.insert_node(3),
    luasnip.text_node({" {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("st", {
    luasnip.text_node("type "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node({" struct {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("in", {
    luasnip.text_node("type "),
    luasnip.insert_node(1, "name"),
    luasnip.text_node({" interface {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("test", {
    luasnip.text_node("func Test"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node("(t *testing.T) {"),
    luasnip.text_node({"", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  luasnip.snippet("tabtest", {
    luasnip.text_node("func Test"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node({"(t *testing.T) {", "\ttests := []struct {", "\t\tname string", "\t\t"}),
    luasnip.insert_node(2, "input type"),
    luasnip.text_node({"", "\t\twant "}),
    luasnip.insert_node(3, "type"),
    luasnip.text_node({"\t}{", "\t\t{", "\t\t\tname: \""}),
    luasnip.insert_node(4, "test case"),
    luasnip.text_node("\","),
    luasnip.insert_node(0),
    luasnip.text_node({"\t\t},", "\t}", "", "\tfor _, tt := range tests {", "\t\tt.Run(tt.name, func(t *testing.T) {", "\t\t\t// Test implementation", "\t\t})", "\t}", "}"})
  })
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

-- Trouble setup for better quickfix list
require('trouble').setup({
  position = "bottom",
  height = 10,
  icons = true,
  mode = "workspace_diagnostics",
  padding = false,
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

-- Debug Adapter Protocol setup
local dap = require('dap')
local dapui = require("dapui")

-- Configure DAP UI
dapui.setup()

-- Automatically open/close dap-ui when debugging starts/ends
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

-- Debug keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Continue' })
vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })


-- Neovim configuration with Go development focus and enhanced search capabilities

-----------------------------------------------------------
-- Initial Setup
-----------------------------------------------------------
vim.cmd [[packadd packer.nvim]]

-- Create autocommand groups
local format_group = vim.api.nvim_create_augroup("Format", { clear = true })
local go_group = vim.api.nvim_create_augroup("Go", { clear = true })
local filetype_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

-- Set leader key
vim.g.mapleader = " "

-----------------------------------------------------------
-- General Settings
-----------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.colorcolumn = "100"
vim.opt.completeopt = "menu,menuone,noselect"

-- Go-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 8
  end,
  group = filetype_group,
})

-----------------------------------------------------------
-- Plugin Management
-----------------------------------------------------------
require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP and completion
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'
  use 'folke/neodev.nvim' -- For better Lua development

  -- File navigation and search
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          ignore = false,
        },
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      -- Use simpler installation for fzf-native
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
    config = function()
      require('telescope').setup({
        defaults = {
          -- Use ripgrep for faster text searches
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden', -- Search hidden files
            '--glob=!.git/', -- Exclude .git directory
          },
          path_display = { truncate = 3 },
          layout_config = {
            horizontal = { width = 0.95, height = 0.95, preview_width = 0.6 }
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-u>"] = false, -- Clear prompt
              ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
          },
          file_ignore_patterns = { 
            "node_modules", 
            ".git/", 
            "vendor/",
            "%.lock$",
            "%.sum$",
          },
          -- Performance optimizations
          cache_picker = {
            num_pickers = 10, -- Cache results of previous pickers
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          -- For large codebases:
          preview = {
            treesitter = true,
            timeout = 500, -- ms
          },
        },
        pickers = {
          find_files = {
            hidden = true
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        },
      })
      -- Load extensions
      require('telescope').load_extension('fzf')
    end
  }

  -- Additional Telescope extensions
  use {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").load_extension("ui-select")
    end
  }

  use {
    'nvim-telescope/telescope-frecency.nvim', -- Prioritizes frequently accessed files
    requires = {'kkharji/sqlite.lua'},
    config = function()
      require("telescope").load_extension("frecency")
    end
  }

  -- Terminal integration
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
          return 20
        end,
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved'
        },
        -- Better colors for terminal
        highlights = {
          Normal = {
            link = 'Normal',
          },
          NormalFloat = {
            link = 'Normal',
          },
        },
      })

      -- Add terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      -- Auto-command to set terminal keymaps when terminal opens
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
  }

  -- Enhanced Git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 200,
          virt_text_pos = 'eol',
        },
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr})

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr})

          -- Actions
          vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, {buffer=bufnr, desc = "Toggle git blame"})
          vim.keymap.set('n', '<leader>gd', gs.diffthis, {buffer=bufnr, desc = "Diff this"})
          vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end, {buffer=bufnr, desc = "Diff this ~"})
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr, desc = "Stage hunk"})
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr, desc = "Reset hunk"})
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer=bufnr, desc = "Undo stage hunk"})
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr, desc = "Preview hunk"})
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {buffer=bufnr, desc = "Stage buffer"})
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {buffer=bufnr, desc = "Reset buffer"})
          
          -- Visual mode
          vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {buffer=bufnr, desc = "Stage selected hunks"})
          vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {buffer=bufnr, desc = "Reset selected hunks"})
        end
      })
    end
  }
  
  -- Advanced Git diff viewer
  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            width = 35,
            position = "left",
          },
        },
        commit_log_panel = {
          win_config = { height = 12 },
        },
        default_args = {
          DiffviewFileHistory = { "%", "--follow" },
        },
        hooks = {},
        keymaps = {
          view = {
            ["q"] = "<Cmd>DiffviewClose<CR>",
          },
          file_panel = {
            ["q"] = "<Cmd>DiffviewClose<CR>",
            ["gf"] = "<Cmd>DiffviewToggleFiles<CR>",
            ["s"] = "<Cmd>lua require('diffview.actions').toggle_stage_entry()<CR>", -- Stage/unstage the selected entry
          },
          file_history_panel = {
            ["q"] = "<Cmd>DiffviewClose<CR>",
            ["gf"] = "<Cmd>DiffviewToggleFiles<CR>",
          }
        },
      })
      
      -- DiffView keymaps
      vim.keymap.set('n', '<leader>gvd', '<cmd>DiffviewOpen<CR>', { desc = "Open DiffView" })
      vim.keymap.set('n', '<leader>gvs', '<cmd>DiffviewOpen --staged<CR>', { desc = "DiffView staged changes" })
      vim.keymap.set('n', '<leader>gvf', '<cmd>DiffviewFileHistory %<CR>', { desc = "DiffView file history" })
      vim.keymap.set('n', '<leader>gvb', '<cmd>DiffviewFileHistory<CR>', { desc = "DiffView branch history" })
      vim.keymap.set('n', '<leader>gvr', '<cmd>DiffviewRefresh<CR>', { desc = "DiffView refresh" })
      vim.keymap.set('n', '<leader>gvc', '<cmd>DiffviewClose<CR>', { desc = "DiffView close" })
    end
  }
  
  -- Fugitive - comprehensive Git integration
  use {
    'tpope/vim-fugitive',
    requires = 'tpope/vim-rhubarb', -- GitHub integration
  }

  -- UI and theme
  use { 
    'ellisonleao/gruvbox.nvim', 
    priority = 1000,
    config = function()
      local has_gruvbox, gruvbox = pcall(require, "gruvbox")
      if has_gruvbox then
        gruvbox.setup({
          contrast = "hard",
          transparent_mode = false,
          italic = {
            strings = true,
            comments = true,
            operators = false,
            folds = true,
          },
        })
      end
      -- Set colorscheme safely
      pcall(function() vim.cmd("colorscheme gruvbox") end)
    end
  }
  
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      local has_lualine, lualine = pcall(require, 'lualine')
      if has_lualine then
        lualine.setup({
          options = {
            theme = 'gruvbox',
            component_separators = '|',
            section_separators = '',
            globalstatus = true,
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
        })
      end
    end
  }

  -- Error display
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      local has_trouble, trouble = pcall(require, 'trouble')
      if has_trouble then
        trouble.setup({
          position = "bottom",
          height = 15,
          padding = false,
          auto_open = false,
          auto_preview = true,
          auto_close = true,
          use_diagnostic_signs = true
        })
        
        -- Trouble keymaps
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
      end
    end
  }

  -- Go development
  use {
    'ray-x/go.nvim',
    requires = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup({
        goimports = true,
        gofmt = 'gofumpt',
        test_runner = 'go',
        run_in_floaterm = true,
        floaterm = {
          width = 0.8,
          height = 0.8,
          position = 'center',
        },
        trouble = true,
        test_efm = true,
        lsp_cfg = false, -- Set to false to avoid config conflict with our manual setup
        lsp_gofumpt = true,
        lsp_on_attach = false, -- Set to false to avoid config conflict with our manual setup
        dap_debug = true,
        gopls_cmd = {'gopls'},
        gopls_remote_auto = true,
        tag_options = 'json=omitempty',
        sign_priority = 100,
      })

      -- Go keymaps
      local map = vim.keymap.set
      map('n', '<leader>tt', '<cmd>GoTest -v<CR>', { noremap = true })
      map('n', '<leader>tf', '<cmd>GoTestFile -v<CR>', { noremap = true })
      map('n', '<leader>tn', '<cmd>GoTestFunc -v<CR>', { noremap = true })
      map('n', '<leader>tc', '<cmd>GoCoverage<CR>', { noremap = true })
      map('n', '<leader>gi', '<cmd>GoImports<CR>', { noremap = true })
      map('n', '<leader>gf', '<cmd>GoFormat<CR>', { noremap = true })
      map('n', '<leader>gr', '<cmd>GoRun<CR>', { noremap = true })
      map('n', '<leader>ga', '<cmd>GoAlt!<CR>', { noremap = true })
      map('n', '<leader>gm', '<cmd>GoModTidy<CR>', { noremap = true })
      map('n', '<leader>ge', '<cmd>GoIfErr<CR>', { noremap = true })
      
      -- Go-specific search mappings (shorter, more memorable)
      map('n', '<leader>gs', '<cmd>Telescope lsp_document_symbols symbols=go<CR>', { noremap = true, desc = "Go symbols" })
      map('n', '<leader>gS', '<cmd>Telescope lsp_workspace_symbols symbols=go<CR>', { noremap = true, desc = "Go workspace symbols" })
      map('n', '<leader>gi', '<cmd>Telescope lsp_implementations<CR>', { noremap = true, desc = "Go implementations" })
      map('n', '<leader>gr', '<cmd>Telescope lsp_references<CR>', { noremap = true, desc = "Go references" })
    end
  }

  -- Auto-pairs
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" },
        enable_check_bracket_line = true,
        check_ts = true,
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey='Comment'
        },
      })
      -- Make autopairs and completion work together
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  }

  -- Syntax and language support
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'go', 'lua', 'markdown', 'markdown_inline', 'yaml', 'json', 'sql', 'bash' },
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
            scope_incremental = '<TAB>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
        },
      })
    end
  }
  
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  
  -- Comment plugin
  use {
    'numToStr/Comment.nvim',
    config = function()
      local has_comment, comment = pcall(require, 'Comment')
      if has_comment then
        comment.setup()
      end
    end
  }
  
  -- Indent guides
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      -- Check if the new API is available, otherwise use legacy setup
      local has_ibl, ibl = pcall(require, "ibl")
      if has_ibl then
        ibl.setup {
          indent = { char = "│" },
          scope = { enabled = true },
        }
      else
        -- Fallback to legacy indent-blankline setup
        pcall(function()
          require("indent_blankline").setup {
            char = "│",
            show_current_context = true,
          }
        end)
      end
    end
  }
  
  -- Better UI components
  use {
    "folke/which-key.nvim",
    config = function()
      local has_which_key, which_key = pcall(require, "which-key")
      if has_which_key then
        which_key.setup()
      end
    end
  }
end)

-----------------------------------------------------------
-- Completion and Snippets
-----------------------------------------------------------
-- Load snippets from friendly-snippets (if available)
pcall(function() require("luasnip.loaders.from_vscode").lazy_load() end)

local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- more explicit use
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
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
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Go snippets configuration
luasnip.add_snippets("go", {
  -- Better error handling with context
  luasnip.snippet("iferr", {
    luasnip.text_node({"if err != nil {", "\t"}),
    luasnip.insert_node(1, "return fmt.Errorf(\"failed to %s: %w\", "),
    luasnip.insert_node(2, "task"),
    luasnip.text_node(", err)"),
    luasnip.text_node({"", "}"})
  }),
  
  -- Regular error handling
  luasnip.snippet("errn", {
    luasnip.text_node({"if err != nil {", "\t"}),
    luasnip.insert_node(1, "return err"),
    luasnip.text_node({"", "}"})
  }),

  -- Function snippet with optional receiver
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

  -- Method with receiver
  luasnip.snippet("meth", {
    luasnip.text_node("func ("),
    luasnip.insert_node(1, "r Receiver"),
    luasnip.text_node(") "),
    luasnip.insert_node(2, "name"),
    luasnip.text_node("("),
    luasnip.insert_node(3),
    luasnip.text_node(") "),
    luasnip.insert_node(4),
    luasnip.text_node({" {", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),

  -- Test function
  luasnip.snippet("test", {
    luasnip.text_node("func Test"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node("(t *testing.T) {"),
    luasnip.text_node({"", "\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "}"})
  }),
  
  -- Table test snippet
  luasnip.snippet("ttest", {
    luasnip.text_node({"func Test", ""}),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node({"(t *testing.T) {", "\ttests := []struct{", "\t\tname string", "\t\t"}),
    luasnip.insert_node(2, "input string"),
    luasnip.text_node({"", "\t\t"}),
    luasnip.insert_node(3, "want string"),
    luasnip.text_node({"", "\t}{", "\t\t{", "\t\t\tname: \""}),
    luasnip.insert_node(4, "test case"),
    luasnip.text_node({"\",", "\t\t\t"}),
    luasnip.insert_node(5, "input: \"value\","),
    luasnip.text_node({"", "\t\t\t"}),
    luasnip.insert_node(6, "want: \"expected\","),
    luasnip.text_node({"", "\t\t},", "\t}", "", "\tfor _, tt := range tests {", "\t\tt.Run(tt.name, func(t *testing.T) {", "\t\t\t"}),
    luasnip.insert_node(0, "// test logic"),
    luasnip.text_node({"", "\t\t})", "\t}", "}"}),
  }),
  
  -- Benchmark function
  luasnip.snippet("bench", {
    luasnip.text_node("func Benchmark"),
    luasnip.insert_node(1, "Name"),
    luasnip.text_node("(b *testing.B) {"),
    luasnip.text_node({"", "\tb.ResetTimer()", "\tfor i := 0; i < b.N; i++ {", "\t\t"}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "\t}", "}"})
  }),
})

-----------------------------------------------------------
-- LSP Configuration
-----------------------------------------------------------
-- Neodev setup for better Lua development (safely load if available)
local has_neodev, neodev = pcall(require, "neodev")
if has_neodev then
  neodev.setup()
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
  ensure_installed = { 'gopls', 'lua_ls' },
  automatic_installation = true
})

-- Common on_attach function for all LSP clients
local on_attach = function(client, bufnr)
  -- LSP keymaps
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>fs', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', '<leader>ff', function() vim.lsp.buf.format({ async = true }) end, opts)
  
  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    
  -- Set autoformat
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = format_group,
    })
  end
end

-- Gopls setup
require('lspconfig').gopls.setup({
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
        unusedvariable = true,
        -- fieldalignment was removed in gopls v0.17.0
        -- Now available via hover over struct fields
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      experimentalPostfixCompletions = true,
      -- Disable semantic tokens as they clash with treesitter
      semanticTokens = false
    },
  },
  on_attach = function(client, bufnr)
    -- Disable semantic tokens
    client.server_capabilities.semanticTokensProvider = nil
    
    -- Call common on_attach
    on_attach(client, bufnr)
    
    -- Go-specific import organization
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        for _, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (client.offset_encoding or 'utf-16')
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
      end,
      group = go_group,
    })
  end,
})

-- Lua LSP setup
require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-----------------------------------------------------------
-- Additional Key Mappings
-----------------------------------------------------------
-- File navigation
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>pv', ':NvimTreeFindFile<CR>', { silent = true })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Resize window
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Buffer navigation
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })

-- File finding and search mappings (aligned with popular distributions)
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<CR>', { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = "Grep in files" })
vim.keymap.set('n', '<leader>fw', '<cmd>Telescope grep_string<CR>', { desc = "Find word under cursor" })
vim.keymap.set('n', '<leader>//', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = "Search in current buffer" })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = "List open buffers" })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = "Search help tags" })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope frecency<CR>', { desc = "Recent files" })
vim.keymap.set('n', '<leader>f.', '<cmd>Telescope resume<CR>', { desc = "Resume last search" })

-- Git telescope mappings
vim.keymap.set('n', '<leader>gst', '<cmd>Telescope git_status<CR>', { desc = "Git status (Telescope)" })
vim.keymap.set('n', '<leader>gco', '<cmd>Telescope git_commits<CR>', { desc = "Git commits" })
vim.keymap.set('n', '<leader>gbr', '<cmd>Telescope git_branches<CR>', { desc = "Git branches" })
vim.keymap.set('n', '<leader>gf', '<cmd>Telescope git_files<CR>', { desc = "Git files" })
vim.keymap.set('n', '<leader>gbc', '<cmd>Telescope git_bcommits<CR>', { desc = "Git buffer commits" })
 
-- LSP/Code search mappings
vim.keymap.set('n', '<leader>sr', '<cmd>Telescope lsp_references<CR>', { desc = "Find references" })
vim.keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics<CR>', { desc = "List diagnostics" })
vim.keymap.set('n', '<leader>si', '<cmd>Telescope lsp_implementations<CR>', { desc = "Find implementations" })
vim.keymap.set('n', '<leader>ss', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "Document symbols" }) 
vim.keymap.set('n', '<leader>sS', '<cmd>Telescope lsp_workspace_symbols<CR>', { desc = "Workspace symbols" })

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move text up and down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- Better visual mode paste
vim.keymap.set('v', 'p', '"_dP')

-- Terminal mappings (check if ToggleTerm exists first)
pcall(function()
  vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>')
  vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>')
  vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>')
end)

-- Better searching
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Set diagnostic icons
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

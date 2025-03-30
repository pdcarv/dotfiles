-- Tokyo Night Neovim Configuration with Lazy.nvim

-- Initial Setup
vim.g.mapleader = " " -- Set leader key before loading plugins

-- Create autocommand groups
local format_group = vim.api.nvim_create_augroup("Format", { clear = true })
local go_group = vim.api.nvim_create_augroup("Go", { clear = true })
local filetype_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

-- General settings
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
vim.opt.cmdheight = 2
vim.opt.history = 1000
vim.opt.linespace = 1

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

-- Helper function for keymaps
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specification
require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        on_colors = function(colors)
          colors.blue = "#7aa2f7" -- Slightly warmer blue
          colors.cyan = "#7dcfff" -- Slightly warmer cyan
        end,
        on_highlights = function(highlights, colors)
          highlights.Comment = { fg = "#737aa2" }
          highlights.CursorLine = { bg = "#292e42" }
          highlights.LineNr = { fg = "#3b4261" }
          highlights.CursorLineNr = { fg = "#737aa2" }
        end,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
        dim_inactive = true,
        lualine_bold = true,
      })
      vim.cmd("colorscheme tokyonight-night")
    end
  },

  -- macOS System Appearance Detection
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd('colorscheme tokyonight-night')
          vim.api.nvim_set_option('background', 'dark')
        end,
        set_light_mode = function()
          vim.cmd('colorscheme tokyonight-day')
          vim.api.nvim_set_option('background', 'light')
        end,
      })
      vim.defer_fn(function()
        pcall(function() require("auto-dark-mode").init() end)
      end, 500)
    end
  },

  -- Fast Navigation
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
      map('n', 's', ':HopChar2<CR>', { silent = true })
      map('n', 'S', ':HopWord<CR>', { silent = true })
      map('n', '<leader>j', ':HopLine<CR>', { silent = true })
    end
  },

  -- Quick file switching
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      map('n', '<leader>a', mark.add_file, { desc = "Harpoon add file" })
      map('n', '<C-e>', ui.toggle_quick_menu, { desc = "Harpoon menu" })
      map('n', '<C-1>', function() ui.nav_file(1) end)
      map('n', '<C-2>', function() ui.nav_file(2) end)
      map('n', '<C-3>', function() ui.nav_file(3) end)
      map('n', '<C-4>', function() ui.nav_file(4) end)
    end
  },

  -- Code Structure
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        autofold_depth = 1,
        auto_preview = false,
        keymaps = {
          close = { "<Esc>", "q" },
          goto_location = "<CR>",
          focus_location = "o",
          toggle_preview = "K",
        },
      })
      map('n', '<leader>o', ':SymbolsOutline<CR>', { silent = true, desc = "Toggle outline" })
    end
  },

  -- Multi-cursor
  "mg979/vim-visual-multi",

  -- Code Peeking
  {
    "dnlhc/glance.nvim",
    config = function()
      require("glance").setup({
        border = { enable = true },
        preview_win_opts = { relativenumber = false }
      })
      map('n', 'gd', '<CMD>Glance definitions<CR>')
      map('n', 'gr', '<CMD>Glance references<CR>')
      map('n', 'gi', '<CMD>Glance implementations<CR>')
      map('n', 'gy', '<CMD>Glance type_definitions<CR>')
    end
  },

  -- Smart Folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })

      local ufo = require("ufo")
      map('n', 'zR', function() ufo.openAllFolds() end)
      map('n', 'zM', function() ufo.closeAllFolds() end)
      map('n', 'zr', function() ufo.openFoldsExceptKinds() end)
      map('n', 'K', function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        }
      })

      map("n", "]t", function() require("todo-comments").jump_next() end)
      map("n", "[t", function() require("todo-comments").jump_prev() end)
      map("n", "<leader>td", "<cmd>TodoTelescope<CR>", { desc = "Todo comments" })
    end
  },

  -- Enhanced search and replace
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("spectre").setup()
      map('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>', { desc = "Search and replace" })
      map('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search word" })
    end
  },

  -- Enhanced text objects
  {
    "echasnovski/mini.ai",
    config = function()
      require("mini.ai").setup({
        custom_textobjects = {
          f = require("mini.ai").gen_spec.treesitter({
            a = { '@function.outer' },
            i = { '@function.inner' },
          }),
          c = require("mini.ai").gen_spec.treesitter({
            a = { '@class.outer' },
            i = { '@class.inner' },
          }),
        },
      })
    end
  },

  -- File tree and navigation
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = {
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "all",
        },
        filters = { dotfiles = false },
        git = { ignore = false },
        update_focused_file = {
          enable = true,
          update_root = false,
        },
      })
      map('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = "Toggle file explorer" })
      map('n', '<leader>pv', ':NvimTreeFindFile<CR>', { silent = true, desc = "Find current file" })
    end
  },

  -- File searching
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case', '--hidden',
            '--glob=!.git/'
          },
          path_display = { truncate = 3 },
          layout_config = {
            horizontal = { width = 0.95, height = 0.95, preview_width = 0.6 }
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-u>"] = false,
              ["<C-d>"] = "delete_buffer",
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "vendor/", "%.lock$", "%.sum$",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
        },
        pickers = {
          find_files = { hidden = true }
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
      pcall(function() require("telescope").load_extension('fzf') end)
      pcall(function() require("telescope").load_extension('ui-select') end)
      pcall(function() require("telescope").load_extension('frecency') end)

      -- Telescope keymaps
      map('n', '<leader>f', '<cmd>Telescope find_files hidden=true<CR>', { desc = "Find files" })
      map('n', '<leader>r', '<cmd>Telescope frecency<CR>', { desc = "Recent files" })
      map('n', '<leader>b', '<cmd>Telescope buffers<CR>', { desc = "Buffers" })
      map('n', '<leader>s', '<cmd>Telescope live_grep<CR>', { desc = "Search text" })
      map('n', '<leader>w', '<cmd>Telescope grep_string<CR>', { desc = "Search word" })
      map('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = "Search in buffer" })
      map('n', '<leader>cs', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "Document symbols" })
      map('n', '<leader>cS', '<cmd>Telescope lsp_workspace_symbols<CR>', { desc = "Workspace symbols" })
      map('n', '<leader>cr', '<cmd>Telescope lsp_references<CR>', { desc = "References" })
      map('n', '<leader>cd', '<cmd>Telescope diagnostics<CR>', { desc = "Diagnostics" })
      map('n', '<leader>gs', '<cmd>Telescope git_status<CR>', { desc = "Git status" })
      map('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { desc = "Git commits" })
      map('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', { desc = "Git branches" })
    end
  },

  -- Terminal
  {
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
        float_opts = { border = 'curved' },
      })

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      map('n', '<leader>t', '<cmd>ToggleTerm direction=float<CR>', { desc = "Terminal" })
      map('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = "Horizontal terminal" })
      map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = "Vertical terminal" })
    end
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = { delay = 200, virt_text_pos = 'eol' },
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
          end, { expr = true, buffer = bufnr })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr })

          -- Actions
          vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle git blame" })
          vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = "Diff this" })
          vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end, { buffer = bufnr, desc = "Diff this ~" })
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
        end
      })
    end
  },

  -- Advanced Git diff
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_horizontal" },
          file_history = { layout = "diff2_horizontal" },
        },
        file_panel = {
          listing_style = "tree",
          win_config = { width = 35, position = "left" },
        },
      })

      map('n', '<leader>gvd', '<cmd>DiffviewOpen<CR>', { desc = "Open DiffView" })
      map('n', '<leader>gvs', '<cmd>DiffviewOpen --staged<CR>', { desc = "DiffView staged changes" })
      map('n', '<leader>gvf', '<cmd>DiffviewFileHistory %<CR>', { desc = "DiffView file history" })
      map('n', '<leader>gvb', '<cmd>DiffviewFileHistory<CR>', { desc = "DiffView branch history" })
    end
  },

  -- Fugitive for Git
  { "tpope/vim-fugitive", dependencies = { "tpope/vim-rhubarb" } },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("dap-go").setup()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      local dap = require("dap")
      local dapui = require("dapui")

      map('n', '<F5>', function() dap.continue() end)
      map('n', '<F10>', function() dap.step_over() end)
      map('n', '<F11>', function() dap.step_into() end)
      map('n', '<F12>', function() dap.step_out() end)
      map('n', '<Leader>db', function() dap.toggle_breakpoint() end)
      map('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      map('n', '<Leader>du', function() dapui.toggle() end)
    end
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = 'tokyonight',
          component_separators = '|',
          section_separators = '',
          globalstatus = true,
        },
      })
    end
  },

  -- Error display
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 15,
        padding = false,
        auto_preview = true,
      })

      map("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
      map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
      map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
    end
  },

  -- Go development
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimports = true,
        gofmt = 'gofumpt',
        test_runner = 'go',
        run_in_floaterm = true,
        floaterm = { width = 0.8, height = 0.8, position = 'center' },
        lsp_cfg = false,
        lsp_gofumpt = true,
        lsp_on_attach = false,
        dap_debug = true,
      })

      map('n', '<leader>gt', '<cmd>GoTest -v<CR>', { noremap = true, desc = "Go test" })
      map('n', '<leader>gf', '<cmd>GoTestFunc -v<CR>', { noremap = true, desc = "Go test function" })
      map('n', '<leader>gc', '<cmd>GoCoverage<CR>', { noremap = true, desc = "Go coverage" })
      map('n', '<leader>gI', '<cmd>GoImports<CR>', { noremap = true, desc = "Go imports" })
      map('n', '<leader>gF', '<cmd>GoFormat<CR>', { noremap = true, desc = "Go format" })
      map('n', '<leader>gr', '<cmd>GoRun<CR>', { noremap = true, desc = "Go run" })
    end
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        check_ts = true,
        fast_wrap = { map = '<M-e>' },
      })

      -- Connect to cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  },

  -- Treesitter for better syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 'go', 'lua', 'markdown', 'yaml', 'json', 'sql', 'bash' },
        highlight = { enable = true },
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
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })
    end
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
      })
    end
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  },

  -- LSP and completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim", -- For better Lua development
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- Set up LSP
      require("neodev").setup()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { 'gopls', 'lua_ls' },
        automatic_installation = true
      })

      -- LSP config
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Common on_attach function for all LSP clients
      local on_attach = function(client, bufnr)
        -- LSP keymaps
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
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
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
              unusedvariable = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            experimentalPostfixCompletions = true,
            semanticTokens = false
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
          on_attach(client, bufnr)

          -- Go-specific import organization
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
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
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Completion setup
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
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
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

      -- Use buffer source for `/` and cmdline for ':'
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
      })

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Go snippets
      luasnip.add_snippets("go", {
        luasnip.snippet("iferr", {
          luasnip.text_node({ "if err != nil {", "\t" }),
          luasnip.insert_node(1, "return fmt.Errorf(\"failed to %s: %w\", "),
          luasnip.insert_node(2, "task"),
          luasnip.text_node(", err)"),
          luasnip.text_node({ "", "}" })
        }),

        luasnip.snippet("errn", {
          luasnip.text_node({ "if err != nil {", "\t" }),
          luasnip.insert_node(1, "return err"),
          luasnip.text_node({ "", "}" })
        }),

        -- More Go snippets...
      })
    end
  },
})

-- Additional keymaps
-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Resize window with Alt+arrows
map('n', '<M-Up>', ':resize -2<CR>', { silent = true })
map('n', '<M-Down>', ':resize +2<CR>', { silent = true })
map('n', '<M-Left>', ':vertical resize -2<CR>', { silent = true })
map('n', '<M-Right>', ':vertical resize +2<CR>', { silent = true })

-- Buffer navigation
map('n', '<Tab>', ':bnext<CR>', { silent = true })
map('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
map('n', '<leader>x', ':bdelete<CR>', { silent = true, desc = "Close buffer" })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move text up and down
map('v', '<A-j>', ":m '>+1<CR>gv=gv")
map('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- Better visual mode paste
map('v', 'p', '"_dP')

-- Better searching
map('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = "Clear highlights" })

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
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

-- Print a startup message
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.notify("Neovim configuration loaded successfully with Lazy.nvim!", vim.log.levels.INFO)
  end,
})

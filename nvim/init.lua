-- Initial Setup
vim.g.mapleader = " " -- Set leader key before loading plugins

-- Disable netrw (Vim's default file browser)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.linespace = 4
vim.opt.guifont = "JetBrains Mono:h14"

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
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configure Gruvbox base settings
      require("gruvbox").setup({
        contrast = "hard",
        palette_overrides = {
          dark0_hard = "#1d2021",  -- Darker background for night
          light0_hard = "#f9f5d7", -- Lighter background for day
        },
        overrides = {
          Comment = { italic = false },
          ["@keyword"] = { italic = false },
        },
        dim_inactive = false,
      })

      -- Default to dark mode if auto-dark-mode fails
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end
  },

  {
    "f-person/auto-dark-mode.nvim",
    event = "VimEnter",
    config = function()
      local ok, auto_dark_mode = pcall(require, "auto-dark-mode")
      if not ok then
        vim.notify("auto-dark-mode plugin not found. Run :Lazy sync to install.", vim.log.levels.WARN)
        return
      end

      auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.o.background = "dark"
          vim.cmd("colorscheme gruvbox")
          -- Enhance visibility in dark mode
          vim.cmd [[highlight DiagnosticError guifg=#fb4934 gui=bold]]
          vim.cmd [[highlight DiagnosticWarn guifg=#fabd2f gui=bold]]
          vim.cmd [[highlight NvimTreeFolderIcon guifg=#fabd2f]]
          vim.cmd [[highlight DevIconDefault guifg=#d3869b]]
        end,
        set_light_mode = function()
          vim.o.background = "light"
          vim.cmd("colorscheme gruvbox")
          -- Enhance visibility in light mode
          vim.cmd [[highlight DiagnosticError guifg=#9d0006 gui=bold]]
          vim.cmd [[highlight DiagnosticWarn guifg=#b57614 gui=bold]]
          vim.cmd [[highlight NvimTreeFolderIcon guifg=#b57614]]
          vim.cmd [[highlight DevIconDefault guifg=#8f3f71]]
        end,
      })

      pcall(function() auto_dark_mode.init() end)
    end
  },

  -- Fast Navigation
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = { "s", "S", "<leader>j" }, -- Lazy-load on key combinations
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
    keys = { "<leader>a", "<C-e>", "<C-1>", "<C-2>", "<C-3>", "<C-4>" }, -- Lazy-load
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

  -- Code Structure - Modified for auto-open
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline", -- Lazy-load on command
    keys = { "<leader>o" }, -- Lazy-load on key
    config = function()
      require("symbols-outline").setup({
        autofold_depth = 1,
        auto_preview = false,
        position = 'right', -- Place on the right side
        width = 35,         -- Slightly wider for better method visibility
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
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost", -- Lazy-load after buffer is read
  },

  -- Code Peeking
  {
    "dnlhc/glance.nvim",
    keys = { "gd", "gr", "gi", "gy" }, -- Lazy-load on keys
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
    event = "BufReadPost", -- Lazy-load after buffer is read
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
    event = "BufReadPost",               -- Lazy-load after buffer is read
    keys = { "]t", "[t", "<leader>td" }, -- Load on these keys
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
    keys = { "<leader>S", "<leader>sw" }, -- Lazy-load on keys
    config = function()
      require("spectre").setup()
      map('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>', { desc = "Search and replace" })
      map('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search word" })
    end
  },

  -- Enhanced text objects
  {
    "echasnovski/mini.ai",
    event = "BufReadPost", -- Lazy-load after buffer is read
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

  -- File tree and navigation - Modified for wider view
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { "<leader>e", "<leader>pv" },           -- Lazy-load on keys
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, -- Lazy-load on command
    init = function()
      -- This runs at startup but doesn't load the full plugin yet
      vim.defer_fn(function() vim.cmd("NvimTreeToggle") end, 10)
    end,
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 40,
          adaptive_size = false,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "all",
          indent_markers = {
            enable = true,
            icons = {
              corner = "└ ",
              edge = "│ ",
              item = "│ ",
              none = "  ",
            },
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
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

  -- File searching - Optimized for performance
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-frecency.nvim",   dependencies = { "kkharji/sqlite.lua" } },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope", -- Lazy-load on command
    keys = {           -- Lazy-load on all these keys
      "<leader>p", "<leader>f", "<leader>r", "<leader>b", "<leader>s",
      "<leader>w", "<leader>/", "<leader>.", "<leader>cs", "<leader>cS",
      "<leader>cr", "<leader>cd", "<leader>gs", "<leader>gc", "<leader>gb"
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          -- Disable previews for performance
          previewer = false,

          -- Optimized ripgrep settings
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
            '--glob=!node_modules/',
            '--glob=!vendor/',
            '--glob=!*.min.*',
            '--glob=!*.map',
            '--threads=8',
          },

          -- Enhanced caching
          cache_picker = {
            num_pickers = 20,
            limit_entries = 1000,
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
              ["<esc>"] = "close", -- Close with a single Esc press
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "vendor/", "%.lock$", "%.sum$",
            "%.min.*", "%.map", "%.svg", "%.png", "%.jpg", "%.jpeg",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          -- Performance optimizations
          scroll_strategy = "limit",
          dynamic_preview_title = false,
          results_title = false,
        },

        pickers = {
          find_files = {
            hidden = true,
            -- Use fd for faster file finding if available
            find_command = vim.fn.executable("fd") == 1 and
                { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" } or nil
          },
          -- Optimize live_grep
          live_grep = {
            debounce = 100,
          },
          -- Optimize buffers
          buffers = {
            sort_lastused = true,
            sort_mru = true,
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            hijack_netrw = true,
            hidden_files = true,
          },
        },
      })

      -- Load extensions safely
      local extensions = { 'fzf', 'ui-select', 'frecency', 'file_browser' }
      for _, ext in ipairs(extensions) do
        pcall(function() telescope.load_extension(ext) end)
      end

      -- Smart file search function: git_files (fast) first, then find_files as fallback
      local function project_files()
        local ok = pcall(require('telescope.builtin').git_files)
        if not ok then
          require('telescope.builtin').find_files()
        end
      end

      -- Optimized file search mappings
      map('n', '<leader>p', project_files, { desc = "Project files (git first)" })
      map('n', '<leader>f', function() require('telescope.builtin').find_files() end, { desc = "Find files" })
      map('n', '<leader>r', function() require('telescope.builtin').frecency() end, { desc = "Recent files" })
      map('n', '<leader>b', function() require('telescope.builtin').buffers() end, { desc = "Buffers" })
      map('n', '<leader>s', function() require('telescope.builtin').live_grep() end, { desc = "Search text" })
      map('n', '<leader>w', function() require('telescope.builtin').grep_string() end, { desc = "Search word" })
      map('n', '<leader>/', function() require('telescope.builtin').current_buffer_fuzzy_find() end,
        { desc = "Search in buffer" })
      map('n', '<leader>.', function() require('telescope.builtin').file_browser() end, { desc = "File browser" })
      map('n', '<leader>cs', function() require('telescope.builtin').lsp_document_symbols() end,
        { desc = "Document symbols" })
      map('n', '<leader>cS', function() require('telescope.builtin').lsp_workspace_symbols() end,
        { desc = "Workspace symbols" })
      map('n', '<leader>cr', function() require('telescope.builtin').lsp_references() end, { desc = "References" })
      map('n', '<leader>cd', function() require('telescope.builtin').diagnostics() end, { desc = "Diagnostics" })
      map('n', '<leader>gs', function() require('telescope.builtin').git_status() end, { desc = "Git status" })
      map('n', '<leader>gc', function() require('telescope.builtin').git_commits() end, { desc = "Git commits" })
      map('n', '<leader>gb', function() require('telescope.builtin').git_branches() end, { desc = "Git branches" })

      -- Cache clearing command
      vim.api.nvim_create_user_command("TelescopeCacheClear", function()
        require('telescope.state').reset_cache()
        vim.notify("Telescope cache cleared", vim.log.levels.INFO)
      end, { desc = "Clear Telescope cache" })
    end
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    keys = { "<c-\\>", "<leader>t", "<leader>th", "<leader>tv" }, -- Lazy-load on keys
    cmd = "ToggleTerm",                                           -- Lazy-load on command
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
    event = "BufReadPre", -- Lazy-load when reading a file
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
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },                       -- Lazy-load on commands
    keys = { "<leader>gvd", "<leader>gvs", "<leader>gvf", "<leader>gvb" }, -- Lazy-load on keys
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
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    cmd = { "Git", "Gread", "Gwrite", "Gdiffsplit", "Gvdiffsplit" }, -- Lazy-load on commands
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = { -- Lazy-load on keys
      "<F5>", "<F10>", "<F11>", "<F12>",
      "<Leader>db", "<Leader>dB", "<Leader>du", "<leader>dd"
    },
    config = function()
      require("dap-go").setup()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      local dap = require("dap")
      local dapui = require("dapui")

      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        }
      }

      -- Configure Go debugging
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = "${fileDirname}"
        }
      }

      -- Set debugging keymaps
      map('n', '<F5>', function() dap.continue() end)
      map('n', '<F10>', function() dap.step_over() end)
      map('n', '<F11>', function() dap.step_into() end)
      map('n', '<F12>', function() dap.step_out() end)
      map('n', '<Leader>db', function() dap.toggle_breakpoint() end)
      map('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      map('n', '<Leader>du', function() dapui.toggle() end)

      -- Add specialized debug command
      map('n', '<leader>dd', function()
        local filetype = vim.bo.filetype
        if filetype == "go" then
          local file = vim.fn.expand('%:p')
          local dir = vim.fn.expand('%:p:h')

          -- Check if this is a test file
          local is_test = string.match(file, "_test%.go$")

          if is_test then
            require('dap-go').debug_test()
          else
            -- For regular Go files, try to find main package
            dap.run({
              type = "go",
              name = "Debug",
              request = "launch",
              program = dir,
              args = {},
            })
          end
        else
          -- For other filetypes
          dap.continue()
        end
      end, { desc = "Smart debug" })
    end
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter", -- Lazy-load on vim enter
    config = function()
      require("lualine").setup({
        options = {
          theme = 'gruvbox',
          component_separators = '|',
          section_separators = '',
          globalstatus = true,
        },
      })
    end
  },

  -- Error display - Simplified configuration
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "TroubleToggle",                               -- Lazy-load on command
    keys = { "<leader>xx", "<leader>xd", "<leader>xw" }, -- Lazy-load on keys
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 12,
        padding = false,
        auto_open = false, -- Explicitly disable auto_open
        auto_close = false,
        auto_preview = true,
        mode = "workspace_diagnostics",
      })

      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
      map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
      map("n", "<leader>xw", "<cmd>Trouble symbols toggle focus=false<cr>", { silent = true, noremap = true })
    end
  },

  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "go", -- Lazy-load on Go files only
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
        trouble = true,
        luasnip = true,
        icons = { breakpoint = '🛑', currentpos = '▶️' },
        lsp_codelens = true,
        lsp_keymaps = false, -- We'll define our own
        diagnostic = {
          hdlr = true,
          underline = true,
          virtual_text = { space = 0, prefix = "■" },
          signs = true,
          update_in_insert = false,
        },
      })

      map('n', '<leader>gt', '<cmd>GoTest -v<CR>', { noremap = true, desc = "Go test" })
      map('n', '<leader>gf', '<cmd>GoTestFunc -v<CR>', { noremap = true, desc = "Go test function" })
      map('n', '<leader>gc', '<cmd>GoCoverage<CR>', { noremap = true, desc = "Go coverage" })
      map('n', '<leader>gI', '<cmd>GoImports<CR>', { noremap = true, desc = "Go imports" })
      map('n', '<leader>gF', '<cmd>GoFormat<CR>', { noremap = true, desc = "Go format" })
      map('n', '<leader>gr', '<cmd>GoRun<CR>', { noremap = true, desc = "Go run" })

      map('n', '<leader>gat', '<cmd>GoAddTag<CR>', { noremap = true, desc = "Go add tags" })
      map('n', '<leader>grt', '<cmd>GoRmTag<CR>', { noremap = true, desc = "Go remove tags" })
      map('n', '<leader>gfs', '<cmd>GoFillStruct<CR>', { noremap = true, desc = "Go fill struct" })
      map('n', '<leader>gfs', '<cmd>GoFillSwitch<CR>', { noremap = true, desc = "Go fill switch" })
      map('n', '<leader>gif', '<cmd>GoIfErr<CR>', { noremap = true, desc = "Go if err" })
      map('n', '<leader>gim', '<cmd>GoImpl<CR>', { noremap = true, desc = "Go implement interface" })
    end
  },

  {
    "ray-x/navigator.lua",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig"
    },
    ft = "go",
    config = function()
      require("navigator").setup({
        debug = false,
        width = 0.75,
        height = 0.3,
        preview_height = 0.35,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        on_attach = function(client, bufnr)
          -- Enhanced navigation for large codebases
        end,
        treesitter_analysis = true,
        transparency = 10,
        lsp_signature_help = true,
        signature_help_cfg = { max_width = 80 },
        lsp = {
          enable = true,
          code_action = { enable = true, sign = true, virtual_text = true },
          code_lens_action = { enable = true, sign = true, virtual_text = true },
          format_on_save = false,           -- We handle this separately
          disable_format_cap = { "gopls" }, -- Prevent conflicts
        },
      })
    end
  },

  
  {
    "crusj/structrue-go.nvim",
    ft = "go",
    config = function()
      require("structrue-go").setup({
        show_filename = true,
        show_struct_field_line = true,
        number = true,
        fold = {
          augroup_name = "StructrueGo",
          enable = true,
        },
      })
      map('n', '<leader>gst', '<cmd>GoStructure<CR>', { noremap = true, desc = "Go structure view" })
    end
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Only load when entering insert mode
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        check_ts = true,
        fast_wrap = { map = '<M-e>' },
      })
    end
  },

  -- Treesitter for better syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = { "BufReadPost", "BufNewFile" }, -- Load when buffer is read/created
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
    event = "BufReadPost", -- Lazy-load after buffer is read
    config = function()
      require("Comment").setup()
    end
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost", -- Lazy-load after buffer is read
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
    event = "VeryLazy", -- Load this after everything else
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
      "nvim-tree/nvim-web-devicons",        -- For completion icons
    },
    event = { "BufReadPre", "BufNewFile" }, -- Load LSP for real files
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

        -- Add tag navigation replacement using LSP
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

        -- Diagnostic keymaps
        vim.keymap.set('n', '[d', function()
          vim.diagnostic.jump({ backward = true, float = true })
        end)
        vim.keymap.set('n', ']d', function()
          vim.diagnostic.jump({ forward = true, float = true })
        end)
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

      
      require('lspconfig').gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            -- Enhanced completion and analysis
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
              unusedvariable = true,
              
              composites = true,    -- Composite literal improvements
              ST1003 = true,        -- Go naming conventions
              printf = true,        -- Printf format string analysis
              httpresponse = true,  -- HTTP response body usage
              stringintconv = true, -- String-int conversion analysis
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            experimentalPostfixCompletions = true,
            semanticTokens = false,

            
            completionDocumentation = true,
            deepCompletion = true,
            matcher = "Fuzzy",
            completionBudget = "100ms",

            
            codelenses = {
              gc_details = true,         -- Memory allocation details
              generate = true,           -- go generate commands
              regenerate_cgo = true,     -- CGO regeneration
              test = true,               -- Test run/debug buttons
              tidy = true,               -- go mod tidy suggestions
              upgrade_dependency = true, -- Dependency updates
              vendor = true,             -- Vendor management
            },

            
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            
            vulncheck = "Imports",           -- Vulnerability checking
            templateExtensions = {},         -- Template file extensions
            env = {
              GOFLAGS = "-tags=integration", -- Build tags for completion
            },
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

     -- Performance-Optimized Completion Engine with Advanced Snippets
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- Helper functions for snippet conditions
      local function in_function()
        local node = vim.treesitter.get_node()
        while node do
          if node:type() == "function_declaration" or node:type() == "method_declaration" then
            return true
          end
          node = node:parent()
        end
        return false
      end

      local function in_test_function()
        local node = vim.treesitter.get_node()
        while node do
          if node:type() == "function_declaration" then
            local name_nodes = node:field("name")
            if name_nodes and #name_nodes > 0 then
              local name = vim.treesitter.get_node_text(name_nodes[1], 0)
              return name:match("^Test") or name:match("^Benchmark") or name:match("^Example")
            end
          end
          node = node:parent()
        end
        return false
      end

      local function at_line_start()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        return line:sub(1, col):match("^%s*$") ~= nil
      end

      -- Enhanced LuaSnip configuration for advanced snippet management
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = false, -- Manual control
        store_selection_keys = "<Tab>",
        -- Performance optimization for large files
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = { { "●", "Orange" } }
            }
          }
        },
      })

      -- Comprehensive Go snippet library focused on core constructs
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local c = ls.choice_node
      local f = ls.function_node
      local fmt = require("luasnip.extras.fmt").fmt

      ls.add_snippets("go", {
        -- Error Handling Patterns
        s("iferr", {
          t({ "if err != nil {", "\treturn err", "}" })
        }),

        s("errw", {
          fmt([[
if err != nil {{
	return fmt.Errorf("{}: %w", err)
}}]], {
            i(1, "operation failed")
          })
        }),

        s("errn", {
          fmt([[
if err != nil {{
	return {}
}}]], {
            c(1, {
              t("nil, err"),
              t("err"),
              t("false, err"),
              t("0, err"),
            })
          })
        }),

        s("errc", {
          fmt([[
if err != nil {{
	{}: {}
	return {}
}}]], {
            c(1, {
              t("log.Printf"),
              t("log.Error"),
              t("fmt.Printf"),
            }),
            i(2, "\"error: %v\", err"),
            i(3, "err")
          })
        }),

        -- Function and Method Declarations
        s("fn", {
          fmt([[
func {}({}) {} {{
	{}
}}]], {
            i(1, "name"),
            i(2, ""),
            c(3, {
              t("error"),
              t(""),
              t("(error)"),
              t("(int, error)"),
              t("(bool, error)"),
              t("(*Type, error)"),
            }),
            i(4, "// TODO: implement")
          })
        }),

        s("met", {
          fmt([[
func ({}) {}({}) {} {{
	{}
}}]], {
            i(1, "r *Receiver"),
            i(2, "Method"),
            i(3, ""),
            c(4, {
              t("error"),
              t(""),
              t("(error)"),
              t("(int, error)"),
              t("(bool, error)"),
            }),
            i(5, "// TODO: implement")
          })
        }),

        s("init", {
          fmt([[
func init() {{
	{}
}}]], {
            i(1, "// initialization code")
          }),
          condition = at_line_start
        }),

        -- Struct and Interface Definitions
        s("st", {
          fmt([[
type {} struct {{
	{}
}}]], {
            i(1, "Name"),
            i(2, "Field string")
          }),
          condition = at_line_start
        }),

        s("in", {
          fmt([[
type {} interface {{
	{}
}}]], {
            i(1, "Name"),
            i(2, "Method() error")
          }),
          condition = at_line_start
        }),

        -- Control Flow Constructs
        s("for", {
          fmt([[
for {} {{
	{}
}}]], {
            c(1, {
              t("i := 0; i < n; i++"),
              t("condition"),
              t(""),
            }),
            i(2, "// loop body")
          })
        }),

        s("forr", {
          fmt([[
for {}, {} := range {} {{
	{}
}}]], {
            i(1, "i"),
            i(2, "v"),
            i(3, "slice"),
            i(4, "// range body")
          })
        }),

        s("sw", {
          fmt([[
switch {} {{
case {}:
	{}
default:
	{}
}}]], {
            i(1, "value"),
            i(2, "condition"),
            i(3, "// case body"),
            i(4, "// default body")
          })
        }),

        -- Goroutines and Channels
        s("go", {
          fmt([[
go func() {{
	{}
}}()]], {
            i(1, "// goroutine body")
          })
        }),

        s("ch", {
          fmt([[
{} := make(chan {}{})]], {
            i(1, "ch"),
            i(2, "string"),
            c(3, {
              t(""),
              t(", 1"),  -- buffered
              t(", 10"), -- buffered
            })
          })
        }),

        s("ctx", {
          fmt([[
ctx, cancel := context.WithTimeout(context.Background(), {})
defer cancel()]], {
            c(1, {
              t("30*time.Second"),
              t("time.Minute"),
              t("5*time.Second"),
            })
          })
        }),

        -- Testing Patterns
        s("test", {
          fmt([[
func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
		want {}
	}}{{
		{{
			name: "{}",
			{}: {},
			want: {},
		}},
	}}
	
	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			got := {}
			if got != tt.want {{
				t.Errorf("got %v, want %v", got, tt.want)
			}}
		}})
	}}
}}]], {
            i(1, "Function"),
            i(2, "input string"),
            i(3, "string"),
            i(4, "valid input"),
            i(5, "input"),
            i(6, "\"test\""),
            i(7, "\"expected\""),
            i(8, "functionCall(tt.input)")
          }),
          condition = at_line_start
        }),

        s("bench", {
          fmt([[
func Benchmark{}(b *testing.B) {{
	for i := 0; i < b.N; i++ {{
		{}
	}}
}}]], {
            i(1, "Function"),
            i(2, "// benchmark code")
          }),
          condition = at_line_start
        }),

        -- Common Go Idioms
        s("main", {
          fmt([[
func main() {{
	{}
}}]], {
            i(1, "// main function body")
          }),
          condition = at_line_start
        }),

        s("make", {
          fmt([[
{} := make({}, {})]], {
            i(1, "variable"),
            c(2, {
              t("[]string"),
              t("map[string]string"),
              t("chan string"),
              t("[]int"),
              t("map[string]int"),
            }),
            i(3, "0")
          })
        }),

        s("defer", {
          fmt([[
defer func() {{
	{}
}}()]], {
            i(1, "// cleanup code")
          })
        }),

        -- Interface Implementation Check
        s("impl", {
          fmt([[
var _ {} = (*{})({})]], {
            i(1, "Interface"),
            i(2, "Type"),
            c(3, {
              t("nil"),
              t("&Type{}"),
            })
          }),
          condition = at_line_start
        }),
      })

      -- Enhanced snippet navigation keybindings
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { desc = "Expand or jump to next snippet placeholder" })

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet placeholder" })

      vim.keymap.set("i", "<C-l>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = "Cycle through snippet choices" })

      -- Optimized performance settings for large projects
      cmp.setup({
        performance = {
          debounce = 100,         -- Balanced for large files
          throttle = 60,          -- Smooth typing experience
          fetching_timeout = 300, -- Quick timeout for large codebases
          confirm_resolve_timeout = 120,
          async_budget = 1,
          max_view_entries = 25, -- Focused results for faster scanning
        },

        completion = {
          keyword_length = 2,   -- Still used for buffer/path sources
          completeopt = "menu,menuone,noinsert",
          autocomplete = false, -- Disabled - Manual Alt+Space control
        },

        experimental = {
          ghost_text = {
            hl_group = "Comment",
          },
        },

        -- Optimized matching for large codebases
        matching = {
          disallow_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          }),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          -- Primary completion trigger
          ['<C-Space>'] = cmp.mapping.complete(), -- Alt+Space (M = Meta/Alt key)

          -- Close completion
          ['<Esc>'] = cmp.mapping.abort(),

          -- Navigation in completion menu
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback() -- Normal tab behavior
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback() -- Normal shift-tab behavior
            end
          end, { 'i', 's' }),

          -- Alternative navigation (backup)
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Documentation scrolling
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Confirm completion with Enter
          ['<CR>'] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback() -- Normal Enter behavior
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        }),

        -- Optimized sources for large codebases
        sources = cmp.config.sources({
          {
            name = 'nvim_lsp',
            priority = 1000,
            max_item_count = 20,
            keyword_length = 1,
          },
          {
            name = 'luasnip',
            priority = 750,
            max_item_count = 5,
            keyword_length = 2,
          },
        }, {
          {
            name = 'buffer',
            priority = 300,
            keyword_length = 3,
            max_item_count = 8,
            -- Limit buffer scope for performance in large projects
            option = {
              get_bufnrs = function()
                local bufs = {}
                local current_buf = vim.api.nvim_get_current_buf()

                -- Include current buffer
                bufs[current_buf] = true

                -- Include only visible buffers for performance
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
                    bufs[buf] = true
                  end
                end

                return vim.tbl_keys(bufs)
              end
            }
          },
          {
            name = 'path',
            priority = 250,
            max_item_count = 10,
            keyword_length = 2,
          },
        }),

        -- Enhanced formatting for better visibility
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            local kind_icons = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "",
            }

            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)

            -- Source labels
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]

            -- Add snippet preview for luasnip entries
            if entry.source.name == "luasnip" then
              local snippet = entry:get_completion_item()
              if snippet.documentation then
                vim_item.menu = vim_item.menu .. " (snippet)"
              end
            end

            -- Truncate long completions for performance
            if #vim_item.abbr > 60 then
              vim_item.abbr = string.sub(vim_item.abbr, 1, 57) .. "..."
            end

            return vim_item
          end,
        },

        -- Sorting for relevance in large codebases
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })

      -- Command line completion (minimal for performance)
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {
            name = 'buffer',
            max_item_count = 10,
          }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'path',
            max_item_count = 10,
          }
        }, {
          {
            name = 'cmdline',
            max_item_count = 15,
          }
        })
      })

      -- Load default snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Enhanced autopairs integration
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      
      -- Extract interface from struct
      vim.api.nvim_create_user_command("GoExtractInterface", function()
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.title:find("Extract to interface") or action.title:find("extract interface")
          end,
          apply = true,
        })
      end, { desc = "Extract interface from Go struct" })

      -- Add missing imports
      vim.api.nvim_create_user_command("GoAddImports", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end, { desc = "Add missing Go imports" })

      -- Generate constructor function
      vim.api.nvim_create_user_command("GoGenerateConstructor", function()
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.title:find("Generate constructor") or action.title:find("constructor")
          end,
          apply = true,
        })
      end, { desc = "Generate constructor function" })

      -- Add struct tags
      vim.api.nvim_create_user_command("GoAddStructTags", function()
        local input = vim.fn.input("Tag (json,yaml,xml): ", "json")
        if input ~= "" then
          vim.cmd("GoAddTag " .. input)
        end
      end, { desc = "Add struct tags" })

      -- Remove unused imports
      vim.api.nvim_create_user_command("GoRemoveUnusedImports", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.removeUnusedImports" } },
          apply = true,
        })
      end, { desc = "Remove unused imports" })

      -- Module analysis for large codebases
      vim.api.nvim_create_user_command("GoModuleAnalysis", function()
        local clients = vim.lsp.get_active_clients({ name = "gopls" })
        if #clients == 0 then
          vim.notify("gopls not active", vim.log.levels.WARN)
          return
        end

        vim.notify("Running module analysis...", vim.log.levels.INFO)
        vim.lsp.buf.code_action({
          context = { only = { "source.tidy" } },
          apply = true,
        })
      end, { desc = "Analyze Go module dependencies" })

      -- Snippet management commands
      vim.api.nvim_create_user_command("SnippetList", function()
        local snippets = luasnip.get_snippets("go")
        local snippet_names = {}
        for _, snippet in ipairs(snippets) do
          table.insert(snippet_names, snippet.trigger)
        end
        table.sort(snippet_names)
        vim.notify("Available Go snippets:\n" .. table.concat(snippet_names, ", "), vim.log.levels.INFO)
      end, { desc = "List all Go snippets" })

      vim.api.nvim_create_user_command("SnippetReload", function()
        luasnip.cleanup()
        -- Re-run the snippet definitions
        vim.cmd("luafile " .. vim.fn.stdpath("config") .. "/init.lua")
        vim.notify("Snippets reloaded", vim.log.levels.INFO)
      end, { desc = "Reload snippets" })

      -- Performance monitoring command
      vim.api.nvim_create_user_command("CmpStats", function()
        print("Completion performance:")
        print("- Sources loaded: " .. #cmp.core.sources)
        print("- Cache size: " .. vim.tbl_count(cmp.core.view.entries or {}))
        print("- Active: " .. tostring(cmp.visible()))
      end, { desc = "Show completion performance stats" })

      -- Disable completion in large files (>10k lines) for performance
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          local lines = vim.api.nvim_buf_line_count(0)
          if lines > 10000 then
            vim.b.cmp_enabled = false
            vim.notify("Completion disabled for large file (" .. lines .. " lines)", vim.log.levels.INFO)
          end
        end,
      })

      -- Re-enable completion command for large files
      vim.api.nvim_create_user_command("CmpEnable", function()
        vim.b.cmp_enabled = true
        vim.notify("Completion re-enabled", vim.log.levels.INFO)
      end, { desc = "Re-enable completion for current buffer" })

      -- Show completion keybindings command
      vim.api.nvim_create_user_command("CmpHelp", function()
        local help_text = [[
Completion Workflow:
• Alt+Space: Trigger completion menu
• Tab/Shift+Tab: Navigate up/down in menu
• Enter: Confirm selected completion
• Esc: Close completion menu

Snippet Navigation:
• Tab: Jump to next snippet placeholder
• Shift+Tab: Jump to previous snippet placeholder
• Ctrl+K: Expand or jump forward
• Ctrl+J: Jump backward
• Ctrl+L: Cycle through choices

Go Commands:
• :GoExtractInterface - Extract interface from struct
• :GoAddImports - Add missing imports
• :GoGenerateConstructor - Generate constructor
• :GoAddStructTags - Add struct tags
• :GoRemoveUnusedImports - Clean unused imports
• :GoModuleAnalysis - Analyze dependencies

Performance Commands:
• :CmpStats - Show completion performance
• :CmpEnable - Re-enable in large files
• :SnippetList - List all Go snippets
• :SnippetReload - Reload snippets
        ]]
        vim.notify(help_text, vim.log.levels.INFO)
      end, { desc = "Show completion help" })
    end
  },
})


vim.api.nvim_create_user_command("GoPerformanceStats", function()
  local stats = {
    "=== Go Development Performance Stats ===",
    "LSP Status: " .. (vim.lsp.get_active_clients({ name = "gopls" })[1] and "Active" or "Inactive"),
    "Completion Sources: " .. (#require('cmp').core.sources or 0),
    "Treesitter: " .. (vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] and "Active" or "Inactive"),
    "Buffer Size: " .. vim.api.nvim_buf_line_count(0) .. " lines",
    "File Type: " .. vim.bo.filetype,
  }

  vim.notify(table.concat(stats, "\n"), vim.log.levels.INFO)
end, { desc = "Show Go development performance stats" })


vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }

    -- Enhanced Go navigation
    vim.keymap.set('n', '<leader>gei', ':GoExtractInterface<CR>',
      vim.tbl_extend("force", opts, { desc = "Extract interface" }))
    vim.keymap.set('n', '<leader>gai', ':GoAddImports<CR>', vim.tbl_extend("force", opts, { desc = "Add imports" }))
    vim.keymap.set('n', '<leader>ggc', ':GoGenerateConstructor<CR>',
      vim.tbl_extend("force", opts, { desc = "Generate constructor" }))
    vim.keymap.set('n', '<leader>gast', ':GoAddStructTags<CR>',
      vim.tbl_extend("force", opts, { desc = "Add struct tags" }))
    vim.keymap.set('n', '<leader>grui', ':GoRemoveUnusedImports<CR>',
      vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
    vim.keymap.set('n', '<leader>gma', ':GoModuleAnalysis<CR>',
      vim.tbl_extend("force", opts, { desc = "Module analysis" }))
    vim.keymap.set('n', '<leader>gps', ':GoPerformanceStats<CR>',
      vim.tbl_extend("force", opts, { desc = "Performance stats" }))
  end,
})

-- Startup performance notification
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.notify("🚀 Go-optimized Neovim ready! Use :CmpHelp for keybindings.", vim.log.levels.INFO)
    end, 1000)
  end,
})


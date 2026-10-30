return {
  -- Sessions: restored automatically when starting `nvim` with no arguments in a
  -- directory that has one; only saved while a session is active
  {
    "folke/persistence.nvim",
    event = "VimEnter",
    keys = {
      {
        "<leader>ps",
        function()
          require("persistence").select()
          require("persistence").start()
        end,
        desc = "Select session",
      },
      {
        "<leader>pl",
        function()
          require("persistence").load({ last = true })
          require("persistence").start()
        end,
        desc = "Load last session",
      },
      {
        "<leader>pS",
        function()
          require("persistence").start()
          require("persistence").save()
        end,
        desc = "Save session",
      },
      { "<leader>pd", function() require("persistence").stop() end, desc = "Stop saving session" },
    },
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)
      if vim.fn.argc(-1) == 0 and vim.uv.fs_stat(persistence.current()) then
        vim.schedule(persistence.load)
      else
        persistence.stop()
      end
    end,
  },

  -- Fast Navigation
  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      { "s",         "<cmd>HopChar2<CR>", desc = "Hop to 2 chars" },
      { "S",         "<cmd>HopWord<CR>",  desc = "Hop to word" },
      { "<leader>j", "<cmd>HopLine<CR>",  desc = "Hop to line" },
    },
    opts = {},
  },

  -- Quick file switching
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon file" },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon menu",
      },
      { "<C-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<C-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<C-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<C-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
    config = function()
      require("harpoon"):setup()
    end
  },

  -- Code Structure
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>lo", "<cmd>Outline<CR>", desc = "Symbols outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 35,
        relative_width = false,
      },
      symbol_folding = { autofold_depth = 1 },
      preview_window = { auto_preview = false },
    },
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end,         desc = "Todos" },
    },
    opts = {},
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>",   desc = "File tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal file in tree" },
    },
    init = function()
      -- netrw is disabled, so open the tree only when started on a directory (`nvim .`)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
    opts = {
      sort_by = "case_sensitive",
      view = { width = 40, adaptive_size = false },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "all",
      },
      filters = { dotfiles = false },
      git = { ignore = false },
      update_focused_file = { enable = true, update_root = false },
    },
  },

  -- Pickers (also replaces vim.ui.select)
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end,                 desc = "Project files" },
      { "<leader>fa", function() Snacks.picker.files({ ignored = true }) end, desc = "All files (incl. ignored)" },
      { "<leader>fr", function() Snacks.picker.recent() end,                desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>fg", function() Snacks.picker.grep() end,                  desc = "Live grep" },
      { "<leader>fw", function() Snacks.picker.grep_word() end,             desc = "Grep word" },
      { "<leader>fh", function() Snacks.picker.help() end,                  desc = "Help" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end,           desc = "Document symbols" },
      { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
      { "<leader>f.", function() Snacks.picker.resume() end,                desc = "Resume last picker" },
      { "<leader>/",  function() Snacks.picker.lines() end,                 desc = "Search buffer" },
      { "<leader>gs", function() Snacks.picker.git_status() end,            desc = "Git status" },
      { "<leader>gl", function() Snacks.picker.git_log() end,               desc = "Git log" },
      { "<leader>gb", function() Snacks.picker.git_branches() end,          desc = "Git branches" },
    },
    opts = {
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = true, exclude = { "node_modules", "vendor", "target", "__pycache__" } },
          grep = { hidden = true, exclude = { "node_modules", "vendor", "target", "*.min.*", "*.map" } },
        },
      },
    },
  },
}

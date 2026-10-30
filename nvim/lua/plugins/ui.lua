return {
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<c-\\>",     desc = "Toggle terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",   desc = "Terminal (vertical)" },
    },
    opts = {
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
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    opts = {
      options = {
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        lualine_x = {
          'encoding',
          'fileformat',
          'filetype'
        },
      },
    },
  },

  -- Diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
    },
    opts = {
      win = { size = 12 },
    },
  },

  -- Task runner
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>",    desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    },
    opts = {
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 25,
      },
    },
  },

  -- LSP progress, and warnings/errors from vim.notify in the bottom-right corner
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>xn", "<cmd>Fidget history<cr>", desc = "Message history" },
    },
    opts = {
      notification = {
        override_vim_notify = true,
        filter = vim.log.levels.WARN,
      },
    },
  },
}

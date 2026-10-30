return {
  -- Multi-cursor
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
  },

  -- Search and replace across files
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>rr", function() require("grug-far").open() end, desc = "Replace in files" },
      {
        "<leader>rw",
        function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
        desc = "Replace word",
      },
    },
    opts = {},
  },

  -- Text objects; af/if and ac/ic come from nvim-treesitter-textobjects queries
  {
    "echasnovski/mini.ai",
    event = "BufReadPost",
    dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      })
    end
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt" },
      check_ts = true,
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>c", group = "code (language)" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>m", group = "markdown" },
        { "<leader>o", group = "tasks" },
        { "<leader>p", group = "sessions" },
        { "<leader>r", group = "replace" },
        { "<leader>t", group = "test / terminal" },
        { "<leader>x", group = "diagnostics" },
      })
    end
  },
}

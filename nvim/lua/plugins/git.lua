return {
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>gB", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle line blame" },
    },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 200, virt_text_pos = 'eol' },
    },
  },

  -- Git diff & merge conflict resolution
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      -- During a merge/rebase, DiffviewOpen shows the conflicts in the merge_tool layout
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",          desc = "Diff working tree" },
      { "<leader>gS", "<cmd>DiffviewOpen --staged<CR>", desc = "Diff staged" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>",   desc = "Branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
  },

  -- Fugitive for Git
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    cmd = { "Git", "Gread", "Gwrite", "Gdiffsplit", "Gvdiffsplit", "GBrowse" },
  },

  -- GitHub Integration
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = {
      { "<leader>gp", "<cmd>Octo pr list<CR>",    desc = "List PRs" },
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List issues" },
    },
    opts = {
      picker = "snacks",
      enable_builtin = true,
      default_remote = { "upstream", "origin" },
    },
  },

  -- Conventional Commits (the only remaining Telescope user; loads only on this key)
  {
    "olacin/telescope-cc.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = { { "<leader>gc", "<cmd>Telescope conventional_commits<CR>", desc = "Conventional commit" } },
    config = function()
      require("telescope").load_extension("conventional_commits")
    end
  },
}

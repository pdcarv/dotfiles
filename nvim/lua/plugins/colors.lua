return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        palette_overrides = {
          dark0_hard = "#1d2021",
          light0_hard = "#f9f5d7",
        },
        overrides = {
          Comment = { italic = false },
          ["@keyword"] = { italic = false },
        },
        dim_inactive = false,
      })
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end
  },

  {
    "f-person/auto-dark-mode.nvim",
    event = "VimEnter",
    config = function()
      local ok, auto_dark_mode = pcall(require, "auto-dark-mode")
      if not ok then return end

      auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.o.background = "dark"
          vim.cmd("colorscheme gruvbox")
        end,
        set_light_mode = function()
          vim.o.background = "light"
          vim.cmd("colorscheme gruvbox")
        end,
      })
      pcall(function() auto_dark_mode.init() end)
    end
  },
}

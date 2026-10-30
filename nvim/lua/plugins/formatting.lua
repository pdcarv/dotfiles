return {
  -- Formatting: explicit formatters where we care, the language server otherwise
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        python = { "ruff_organize_imports", "ruff_format" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    },
  },

  -- Linters that are not language servers
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {}
      if vim.fn.executable("golangci-lint") == 1 then
        lint.linters_by_ft.go = { "golangcilint" }
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
        callback = function() lint.try_lint() end,
      })
      lint.try_lint()
    end,
  },
}

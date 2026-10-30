return {
  -- Debugging (Rust debugging is provided by rustaceanvim via :RustLsp debuggables)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug step over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug step into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = "Conditional breakpoint",
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
    },
    config = function()
      require("dap-go").setup()
      -- uv provides debugpy on demand; there is no `python` on PATH
      require("dap-python").setup("uv")
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      require("dap").configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "Run or Test",
          metals = {
            runType = "runOrTestFile",
          },
        },
      }
    end
  },

  -- Unified Testing Framework
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "^2" },
      "nvim-neotest/neotest-python",
      "stevanmilic/neotest-scala",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run file tests" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end,      desc = "Run all tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            go_test_args = { "-v", "-count=1", "-timeout=60s" },
          }),
          -- Detects the project's venv (VIRTUAL_ENV, .venv, poetry, ...)
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
          require("rustaceanvim.neotest"),
          require("neotest-scala"),
        },
        output = { open_on_run = false },
        quickfix = { enabled = false },
        status = { virtual_text = true },
        summary = {
          animated = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "]F",
            output = "o",
            prev_failed = "[F",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
      })
    end
  },

  -- Coverage visualization (generate the report with your test tool, then toggle)
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Coverage", "CoverageToggle", "CoverageSummary" },
    keys = {
      { "<leader>tc", "<cmd>Coverage<CR>",        desc = "Show coverage" },
      { "<leader>tC", "<cmd>CoverageToggle<CR>", desc = "Toggle coverage" },
    },
    opts = {
      auto_reload = true,
      lang = {
        go = { coverage_file = "coverage.out" },
        python = { coverage_file = ".coverage" },
        rust = { coverage_file = "lcov.info" },
      },
    },
  },
}

return {
  -- Rust development (manages rust-analyzer itself; do not vim.lsp.enable it)
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- the plugin is already lazy by filetype
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local function map(lhs, cmd, desc)
              vim.keymap.set("n", lhs, "<cmd>RustLsp " .. cmd .. "<CR>", { buffer = bufnr, desc = desc })
            end
            map("<leader>ch", "hover actions", "Hover actions")
            map("<leader>cr", "runnables", "Runnables")
            map("<leader>ce", "expandMacro", "Expand macro")
            map("<leader>cc", "openCargo", "Open Cargo.toml")
            map("<leader>cp", "parentModule", "Parent module")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
                allTargets = true,
              },
              cargo = {
                allFeatures = true,
                buildScripts = { enable = true },
              },
              procMacro = { enable = true },
              lens = { enable = true },
            },
          },
        },
      }
    end,
  },

  -- Scala development
  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala", "sbt" },
    config = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverProperties = { "-Xmx2G" },
      }
      metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()

      metals_config.on_attach = function(_, bufnr)
        require("metals").setup_dap()

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("<leader>cw", function() require("metals").hover_worksheet() end, "Hover worksheet")
        map("<leader>ct", function() require("metals.tvp").toggle_tree_view() end, "Toggle tree view")
        map("<leader>cT", function() require("metals.tvp").reveal_in_tree() end, "Reveal in tree")
        map("<leader>cc", function() require("metals").compile_cascade() end, "Compile cascade")
        map("<leader>ci", function() require("metals").build_import() end, "Build import")
        map("<leader>cb", function() require("metals").build_connect() end, "Build connect")
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },

  -- Python virtual environment management
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "folke/snacks.nvim" },
    ft = "python",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
    },
    opts = {},
  },

  -- SQL client
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, dependencies = { "tpope/vim-dadbod" } },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.cmd([[Lazy load markdown-preview.nvim]])
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
    },
  },

  -- PlantUML preview
  {
    "weirongxu/plantuml-previewer.vim",
    dependencies = { "tyru/open-browser.vim" },
    ft = { "plantuml", "puml", "uml" },
    cmd = "PlantumlOpen",
  },
}

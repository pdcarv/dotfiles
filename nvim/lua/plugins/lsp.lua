return {
  -- Code Peeking (replaces the built-in grr/gri/grt with Glance previews)
  {
    "dnlhc/glance.nvim",
    keys = {
      { "gd",  "<CMD>Glance definitions<CR>",      desc = "Definitions" },
      { "grr", "<CMD>Glance references<CR>",       desc = "References" },
      { "gri", "<CMD>Glance implementations<CR>",  desc = "Implementations" },
      { "grt", "<CMD>Glance type_definitions<CR>", desc = "Type definitions" },
    },
    opts = {
      border = { enable = true },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Servers enabled here; rust_analyzer is owned by rustaceanvim and metals by nvim-metals
      local servers = {
        'gopls', 'lua_ls', 'pyright', 'ruff', 'nil_ls', 'sqlls', 'jsonls', 'yamlls', 'dockerls',
      }

      require("mason").setup()
      -- nil_ls is left out: Mason builds it with cargo, so install it via brew/nix instead
      require("mason-lspconfig").setup({
        ensure_installed = {
          'gopls', 'lua_ls', 'pyright', 'ruff', 'sqlls', 'jsonls', 'yamlls', 'dockerls', 'rust_analyzer',
        },
        automatic_enable = false,
      })

      -- Formatters used by conform.nvim that are not language servers
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs({ "goimports", "gofumpt" }) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
      })

      -- pyright for types; ruff owns linting, import sorting and formatting
      -- Drop pyright's "x is not accessed" hints; ruff already reports unused names
      local function without_unused_hints(diagnostics)
        return vim.tbl_filter(function(d)
          return not (d.severity == vim.lsp.protocol.DiagnosticSeverity.Hint
            and vim.tbl_contains(d.tags or {}, vim.lsp.protocol.DiagnosticTag.Unnecessary))
        end, diagnostics)
      end

      vim.lsp.config("pyright", {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx)
            if result then result.diagnostics = without_unused_hints(result.diagnostics) end
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
          end,
          ["textDocument/diagnostic"] = function(err, result, ctx)
            if result and result.items then result.items = without_unused_hints(result.items) end
            vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
          end,
        },
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "standard",
            },
          },
        },
      })

      vim.lsp.config("nil_ls", {
        settings = {
          ['nil'] = {
            formatting = { command = { "nixpkgs-fmt" } },
          },
        },
      })

      -- lazydev provides the Neovim runtime/plugin library
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.enable(servers)

      -- Applies to every client, including rustaceanvim and metals
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false -- pyright's hover is richer
          end

          local function map(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map('gD', vim.lsp.buf.declaration, "Declaration")
          map('<leader>la', vim.lsp.buf.code_action, "Code action")
          map('<leader>ln', vim.lsp.buf.rename, "Rename")
        end,
      })
    end
  },
}

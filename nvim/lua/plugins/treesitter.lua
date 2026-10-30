local parsers = {
  'go', 'gomod', 'gosum', 'gowork', 'lua', 'luadoc', 'markdown', 'markdown_inline',
  'yaml', 'json', 'sql', 'bash', 'python', 'rust', 'scala', 'nix', 'dockerfile',
  'toml', 'java', 'kotlin', 'proto', 'vim', 'vimdoc', 'query', 'regex', 'diff',
  'gitcommit',
}

return {
  -- `main` branch: parsers/queries only; highlighting, folds and selection are built into Neovim.
  -- Needs the tree-sitter CLI (brew install tree-sitter-cli). Does not support lazy-loading.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- No-op for parsers that are already installed
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if lang and vim.treesitter.query.get(lang, "indents") then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

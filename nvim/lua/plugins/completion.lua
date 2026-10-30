return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt fuzzy matcher
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()

          local ls = require("luasnip")
          local s = ls.snippet
          local t = ls.text_node
          local i = ls.insert_node
          local fmt = require("luasnip.extras.fmt").fmt

          -- Python snippets
          ls.add_snippets("python", {
            s("def", fmt([[
def {}({}):
    """{}"""
    {}]], {
              i(1, "function_name"),
              i(2, "args"),
              i(3, "docstring"),
              i(4, "pass")
            })),

            s("class", fmt([[
class {}:
    """{}"""

    def __init__(self{}):
            {}]], {
              i(1, "ClassName"),
              i(2, "Class docstring"),
              i(3, ""),
              i(4, "pass")
            })),

            s("test", fmt([[
def test_{}():
    """Test {}"""
    {}]], {
              i(1, "function"),
              i(2, "description"),
              i(3, "assert True")
            })),
          })

          -- Rust snippets
          ls.add_snippets("rust", {
            s("fn", fmt([[
fn {}({}) -> {} {{
    {}
}}]], {
              i(1, "name"),
              i(2, ""),
              i(3, "()"),
              i(4, "todo!()")
            })),

            s("test", fmt([[
#[test]
fn test_{}() {{
    {}
}}]], {
              i(1, "name"),
              i(2, "assert_eq!(1, 1);")
            })),

            s("derive", t("#[derive(Debug, Clone, PartialEq)]")),
          })

          -- SQL snippets
          ls.add_snippets("sql", {
            s("select", fmt([[
SELECT {}
FROM {}
WHERE {}]], {
              i(1, "*"),
              i(2, "table_name"),
              i(3, "1=1")
            })),

            s("create", fmt([[
CREATE TABLE {} (
    id SERIAL PRIMARY KEY,
    {}
);]], {
              i(1, "table_name"),
              i(2, "column_name VARCHAR(255)")
            })),
          })

          -- Nix snippets
          ls.add_snippets("nix", {
            s("pkg", fmt([[
{{ {} }}:
{{
  {}
}}]], {
              i(1, "pkgs"),
              i(2, "# package definition")
            })),

            s("mkder", fmt([[
pkgs.mkDerivation {{
  pname = "{}";
  version = "{}";
  src = {};

  buildInputs = [ {} ];
}}]], {
              i(1, "package-name"),
              i(2, "1.0.0"),
              i(3, "./."),
              i(4, "")
            })),
          })

          -- Scala snippets
          ls.add_snippets("scala", {
            s("def", fmt([[
def {}({}): {} = {{
  {}
}}]], {
              i(1, "functionName"),
              i(2, "args"),
              i(3, "ReturnType"),
              i(4, "???")
            })),

            s("case", fmt([[
case class {}({})]], {
              i(1, "ClassName"),
              i(2, "field: Type")
            })),

            s("test", fmt([[
test("{}") {{
  {}
}}]], {
              i(1, "should do something"),
              i(2, "assert(true)")
            })),
          })
        end,
      },
    },
    opts = {
      -- Completion is manual: <M-Space> opens the menu, nothing pops up while typing
      keymap = {
        preset = "none",
        ["<M-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" }, -- only accepts an explicitly selected item
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then return cmp.select_next() end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then return cmp.select_prev() end
          end,
          "snippet_backward",
          "fallback",
        },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        menu = { auto_show = false },
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true },
      },
      cmdline = { enabled = false },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
          plsql = { "dadbod", "snippets", "buffer" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
}

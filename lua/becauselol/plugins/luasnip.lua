return {
  "L3MON4D3/LuaSnip",
  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },
  config = function ()
      -- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
    require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/lua/becauselol/plugins/luasnippets/"})
  end,
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
}

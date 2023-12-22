return {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd[[colorscheme solarized-osaka]]
  end
}
--return {
--    "craftzdog/solarized-osaka.nvim",--"EdenEast/nightfox.nvim",
--    lazy = false, -- make sure we load this during startup if it is your main colorscheme
--    priority = 1000, -- make sure to load this before all the other start plugins
--    opts = {},
--    config = function()
--      -- load the colorscheme here
--      --vim.cmd([[colorscheme carbonfox]])
--      require("solarized-osaka").setup({
--          --transparent = true
--      })
--    end
--}

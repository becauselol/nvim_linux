return {
    "EdenEast/nightfox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
        --theme = "dragon"
    },
    config = function()
      -- load the colorscheme here
      vim.o.background = ""
      vim.cmd([[colorscheme carbonfox]])
      require("nightfox").setup({
          transparent = true
      })
      vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]]
    end
}

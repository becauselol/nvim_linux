return {
  {

    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          -- ...
        },
        query = {
          -- ...
          latex = "rainbow-blocks",
        },
        highlight = {
          -- ...
        },
      })
    end,
  },
}

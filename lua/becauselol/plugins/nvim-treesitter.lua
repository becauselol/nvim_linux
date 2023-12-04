return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "lua", "python", "markdown", "rust" },
  },
  config = function()
      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
      require("nvim-treesitter.install").prefer_git = false
      local treesitter = require("nvim-treesitter.configs")

      treesitter.setup({
          highlight = {
              enable = true,
          },
      })
  end
}

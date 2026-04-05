-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.journal")
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.api.nvim_set_option("mouse", "")

vim.o.exrc = true

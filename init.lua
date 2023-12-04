vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.wo.number = true
vim.wo.relativenumber = true

-- Copying to system clipboard
-- From current cursor position to EOL (normal mode)
vim.keymap.set({'n'}, '<C-c>', '"+y$')
-- Current selection (visual mode)
vim.keymap.set({'v'}, '<C-c>', '"+y')

-- Cutting to system clipboard
-- From current cursor position to EOL (normal mode)
vim.keymap.set({'n'}, '<C-x>', '"+d$')
-- Current selection (visual mode)
vim.keymap.set({'v'}, '<C-x>', '"+d')

-- For info. on why vim.keymap.set() is preferred over vim.api.nvim_set_keymap(), 
-- see https://github.com/neovim/neovim/commit/6d41f65aa45f10a93ad476db01413abaac21f27d

--require("becauselol.core")
require("becauselol.lazy")

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.wrap = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

function LineNumberColors()
	if vim.o.background == "dark" then
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#89dceb", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#cba6f7", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#f38ba8", bold = false })
	else
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#04a5e5", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#8839ef", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#d20f39", bold = false })
	end
end
LineNumberColors()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = LineNumberColors,
})

opt.spelllang = "en_gb"
opt.clipboard = ""

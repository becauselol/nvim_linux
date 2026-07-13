return {
	"f-person/auto-dark-mode.nvim",
	config = {
		set_dark_mode = function()
			vim.api.nvim_set_option_value("background", "dark", {})
			LineNumberColors()
		end,
		set_light_mode = function()
			vim.api.nvim_set_option_value("background", "light", {})
			LineNumberColors()
		end,
		update_interval = 3000,
		fallback = "dark",
	},
}

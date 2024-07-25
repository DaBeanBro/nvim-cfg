return {
	"craftzdog/solarized-osaka.nvim",
	lazy = true,
	config = function()
		local util = require("solarized-osaka.util")
		local hslutil = require("solarized-osaka.hsl")
		local hsl = hslutil.hslToHex

		require("solarized-osaka").setup({
			transparent = false,
			on_colors = function(colors)
				colors.bg = hsl(210, 40, 11)
			end,
			on_highlights = function(highlights, colors)
				highlights.Colorscheme = {
					bg = colors.fg,
					fg = colors.bg,
				}
				highlights.AlphaButtons = {
					link = "Conceal",
				}
				highlights.AlphaHeader = {
					link = "Debug",
				}
				highlights.AlphaShortcut = {
					link = "@keyword",
				}
			end,
		})
	end,
}

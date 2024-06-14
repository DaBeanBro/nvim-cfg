return {
	"craftzdog/solarized-osaka.nvim",
	lazy = true,
	keys = {
		{ "<leader>fc", "<cmd>Themery<cr>", desc = "Select Colorscheme with Preview" },
	},
	config = function()
		require("solarized-osaka").setup({
			transparent = false,
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

return {
	"folke/which-key.nvim",
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = function()
		local icons = require("utils.icons")
		local whichkey = require("which-key")

		whichkey.register({
			["<leader>"] = {
				f = {
					name = icons.get("ui").Search .. " Fuzzy Find",
					d = {
						name = "DAP_Telescope",
					},
				},
				s = {
					name = icons.get("misc").Ghost .. " Session",
					l = {
						name = "List Sessions",
					},
					n = {
						name = "New Session",
					},
					u = {
						name = "Update Session",
					},
					d = {
						name = "Delete Session",
					},
				},
				d = {
					name = icons.get("ui").Bug .. " DAP",
				},
			},
		})

		whichkey.setup({
			plugins = {
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = true,
					g = true,
				},
			},

			icons = {},

			window = {
				border = "none",
				position = "bottom",
				margin = { 1, 0, 1, 0 },
				padding = { 1, 1, 1, 1 },
				winblend = 0,
			},
		})
	end,
}

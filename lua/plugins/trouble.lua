return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			local edgy = require "edgy"
			vim.opt.splitkeep = "screen"

			vim.keymap.set("n", "<D-b>", function()
				edgy.toggle "left"
			end, { desc = "Toggle sidebar" })
		end,
		dependencies = {
			{
				"folke/trouble.nvim",
				keys = {
					{
						"<leader>xx",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>xs",
						"<cmd>Trouble symbols toggle<cr>",
						desc = "Symbols (Trouble)",
					},
					{
						"<leader>xl",
						"<cmd>Trouble loclist toggle<cr>",
						desc = "Location List (Trouble)",
					},
				},
				opts = {}, -- for default options, refer to the configuration section for custom setup.
				init = function()
					vim.api.nvim_create_autocmd("BufReadPost", {
						pattern = "*",
						callback = function()
							require("trouble").refresh()
						end,
					})
				end,
			},
		},
	},
}

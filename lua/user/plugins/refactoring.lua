return {
	"ThePrimeagen/refactoring.nvim",
	event = "VimEnter",
	keys = {
		{ "<leader>R", mode = "x" },
		{ "gRe", mode = "x" },
		{ "gRf", mode = "x" },
	},
	config = function()
		local map, feedkeys = require("utils").map, require("utils").feedkeys

		local refactoring = require("refactoring")
		refactoring.setup({})

		map("x", "gRe", function()
			return refactoring.refactor("Extract Function")
		end)
		map("x", "gRf", function()
			return refactoring.refactor("Extract Function To File")
		end)
		map("x", "<leader>R", function()
			feedkeys("<Esc>", "n")
			require("telescope").extensions.refactoring.refactors()
		end, "Select refactor")

		require("telescope").load_extension("refactoring")
	end,
}

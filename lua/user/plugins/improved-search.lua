return {
	"backdround/improved-search.nvim",
	init = function()
		local search = require("improved-search")

		-- Search next / previous.
		vim.keymap.set("n", ")", search.stable_next, { noremap = true, silent = true })
		vim.keymap.set("n", "(", search.stable_previous, { noremap = true, silent = true })

		-- Search current word without moving.
		vim.keymap.set("n", "!", search.current_word)

		-- Search selected text in visual mode
		vim.keymap.set("x", "!", search.in_place) -- search selection without moving

		-- Search by motion in place
		vim.keymap.set("n", "|", search.in_place)

		-- clear
		vim.keymap.set("n", "<ESC>", ":set nohlsearch<cr>")
	end,
}

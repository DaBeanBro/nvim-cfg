local M = {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	event = "VeryLazy",
}

function M.config()
	local llines = require("lsp_lines")
	llines.setup()

	vim.diagnostic.config({ virtual_lines = true })
	vim.keymap.set("n", "<leader>ll", llines.toggle, { desc = "Toggle LSP lines" })
end

return M

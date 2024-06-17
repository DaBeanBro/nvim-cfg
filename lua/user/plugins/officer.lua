return {
	"pianocomposer321/officer.nvim",
	dependencies = "stevearc/overseer.nvim",
	dev = true,
	config = function()
		require("officer").setup({})
	end,
}

return {
	"mistricky/codesnap.nvim",
	build = "make build_generator",
	event = "VimEnter",
	keys = {
		{ "<leader>cs", ":CodeSnap<CR>", mode = "x", desc = "Save selected code snapshot into clipboard" },
		{ "<leader>css", ":CodeSnapSave<CR>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
	},
	config = function()
		require("codesnap").setup({
			save_path = "~/Pictures",
			has_breadcrumbs = true,
			watermark = "",
			bg_color = "#535c28",
			title = "vraton.dev from CodeSnap.nvim",
		})
	end,
}

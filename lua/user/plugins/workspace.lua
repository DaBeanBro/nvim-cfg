return {
	"sanathks/workspace.nvim",
	event = "VimEnter",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("workspace").setup({
			workspaces = {
				{ name = "Work", path = "~/projects/", keymap = { "<leader>ws" } },
			},
		})
	end,
}

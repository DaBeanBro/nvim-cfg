return {
	"mbbill/undotree",
	event = "VimEnter",
	enabled = true,
	lazy = true,
	cmd = {
		"UndotreeHide",
		"UndotreeShow",
		"UndotreeFocus",
		"UndotreeToggle",
		"UndotreePersistUndo",
	},
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree", mode = "n" },
	},
}

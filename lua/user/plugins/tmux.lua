return {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	opts = {
		copy_sync = {
			enable = true,
			ignore_buffers = { empty = false },
			redirect_to_clipboard = true,
			register_offset = 0,
			sync_clipboard = true,
			sync_registers = true,
			sync_deletes = true,
			sync_unnamed = true,
		},
		navigation = {
			cycle_navigation = true,
			enable_default_keybindings = true,
			persist_zoom = false,
		},
		resize = {
			enable_default_keybindings = true,
			resize_step_x = 1,
			resize_step_y = 1,
		},
	},
}

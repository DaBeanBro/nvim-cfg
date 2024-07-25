local function dap_telescope_keybind(func_name, args)
	return {
		function()
			require("telescope").extensions.dap[func_name](args)
		end,
		desc = "DAP-telescope: " .. func_name,
	}
end

return {
	"nvim-telescope/telescope-dap.nvim",
	dependencies = {
		"nvim-dap-ui",
		"telescope.nvim",
	},
	keys = {
		{ "<leader>fdm", "<cmd>Telescope dap commands<cr>", desc = "TelescopeDap Commands" },
		{ "<leader>fdc", "<cmd>Telescope dap configurations<cr>", desc = "TelescopeDap Configurations" },
		{ "<leader>fdb", "<cmd>Telescope dap list_breakpoints<cr>", desc = "TelescopeDap List_BreakPoints" },
		{ "<leader>fdv", "<cmd>Telescope dap variables<cr>", desc = "TelescopeDap Variables" },
		{ "<leader>fdf", "<cmd>Telescope dap frames<cr>", desc = "TelescopeDap Frames" },
	},
	config = function()
		require("telescope").load_extension("dap")
	end,
}

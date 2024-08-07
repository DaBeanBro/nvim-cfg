return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	event = "VimEnter",
	config = function()
		require("zen-mode").setup({
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				-- height and width can be:
				-- * an absolute number of cells when > 1
				-- * a percentage of the width / height of the editor when <= 1
				width = 0.8, -- width of the Zen window
				height = 1, -- height of the Zen window
				-- by default, no options are changed for the Zen window
				-- uncomment any of the options below, or add other vim.wo options you want to apply
				options = {
					signcolumn = "no", -- disable signcolumn
					number = false, -- disable number column
					relativenumber = false, -- disable relative numbers
					cursorline = false, -- disable cursorline
					cursorcolumn = false, -- disable cursor column
					foldcolumn = "0", -- disable fold column
					list = false, -- disable whitespace characters
				},
			},
			plugins = {
				-- disable some global vim options (vim.o...)
				-- comment the lines to not apply the options
				options = {
					enabled = true,
					ruler = false,  -- disables the ruler text in the cmd line area
					showcmd = false, -- disables the command in the last line of the screen
				},
				twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = true }, -- disables git signs
				tmux = { enabled = false }, -- disables the tmux statusline
			},
			-- callback where you can add custom code when the Zen window opens
			on_open = function()
				require("gitsigns.actions").toggle_current_line_blame()
				vim.cmd("IBLDisable")
				vim.opt.relativenumber = false
				vim.opt.signcolumn = "no"
				require("gitsigns.actions").refresh()
			end,
			-- callback where you can add custom code when the Zen window closes
			on_close = function()
				require("gitsigns.actions").toggle_current_line_blame()
				vim.cmd("IBLEnable")
				vim.opt.relativenumber = true
				vim.opt.signcolumn = "yes:2"
				require("gitsigns.actions").refresh()
			end,
		})
	end,
}

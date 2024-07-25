local i = require("icons")
return {
	"folke/which-key.nvim",
	dependancies = {
		{ 'echasnovski/mini.icons', version = false },
	},
	event = { "CursorHold", "CursorHoldI" },
	opts = {
		plugins = {
			marks = true,
			registers = true,
		},
		spelling = {
			enabled = false,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		-- Telescope
		{ "<leader>f",  desc = "Files",                                                                     group = "Files",       mode = "n" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>",                                                    desc = "Find File",    mode = "n" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                                                     desc = "Grep Text",    mode = "n" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>",                                                       desc = "Find Buffers", mode = "n" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>",                                                     desc = "Help Tags",    mode = "n" },

		-- ZenMode
		{ "<leader>zt", "<cmd>ZenMode<CR>",                                                                 { desc = "zenmode" },  mode = "n" },

		-- Treesitter
		{ "<leader>Ti", "<cmd>TSConfigInfo<CR>",                                                            desc = "Info" },

		-- Git
		{ "<leader>f",  desc = "Git",                                                                       group = "Git",         mode = "n" },
		{ "<leader>gd", "<cmd>set nosplitright<CR>:execute 'Gvdiff ' .. g:git_base<CR>:set splitright<CR>", desc = "Git Diff",     mode = "n" },
		{ "<leader>gb", "<cmd>Git blame<CR>",                                                               desc = "Git Blame",    mode = "n" },
		{ "<leader>gs", "<cmd>Git<CR>",                                                                     desc = "Git",          mode = "n" },
		{ "<leader>gc", "<cmd>0Gclog<CR>",                                                                  desc = "Gclog",        mode = "n" },
		{
			"<leader>gg",
			function()
				require("lists").change_active("Quickfix")
				vim.cmd(string.format("Git difftool %s", vim.g.git_base))
			end,
			desc = "Git Difftool",
			mode = "n",
		},
		{ "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                          desc = "Reset Buffer" },
		{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                         desc = "Git Diff" },
		{ "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
		{ "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
		{ "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                            desc = "Blame" },
		{ "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                          desc = "Preview Hunk" },
		{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                            desc = "Reset Hunk" },
		{ "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                            desc = "Stage Hunk" },
		{ "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                       desc = "Undo Stage Hunk" },

	},
}

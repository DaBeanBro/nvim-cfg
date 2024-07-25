return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-cheat.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
		{ "Zane-/cder.nvim" },
		{ "rcarriga/nvim-notify" },
		{ "mfussenegger/nvim-dap" },
		{ "rafi/telescope-thesaurus.nvim" },
		{ "ThePrimeagen/git-worktree.nvim" },
	},
	event = "VeryLazy",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local fd_ignore_file = vim.fn.expand("$HOME/") .. ".rgignore"
		local cder_dir_cmd = {
			"fd",
			"-t",
			"d",
			"--hidden",
			"--ignore-file",
			fd_ignore_file,
			".",
		}

		vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = 10 })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { ctermbg = 238 })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { ctermbg = 238 })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { ctermbg = 238 })

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"%build/",
					"%.git/",
					"node_modules/",
					"%.npm/",
					"__pycache__/",
					"%[Cc]ache/",
					"%.dropbox/",
					"%.dropbox_trashed/",
					"%.local/share/Trash/",
					"%.py[c]",
					"%.sw.?",
					"~$",
					"%.tags",
					"%.gemtags",
					"%.tmp",
					"%.plist$",
					"%.pdf$",
					"%.jpg$",
					"%.JPG$",
					"%.jpeg$",
					"%.png$",
					"%.class$",
					"%.pdb$",
					"%.dll$",
				},
				mappings = {
					i = {
						["<C-n>"] = "move_selection_next",
						["<C-p>"] = "move_selection_previous",
						["<C-k>"] = "cycle_history_prev",
						["<C-j>"] = "cycle_history_next",
						["<C-b>"] = "preview_scrolling_up",
						["<C-f>"] = "preview_scrolling_down",
						["<C-q>"] = "close",
						["<C-CR>"] = "to_fuzzy_refine",
					},
				},
				sorting_strategy = "ascending",
				layout_strategy = "center",
				results_title = "",
				borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
				prompt_prefix = ":",
				preview = false,
				layout_config = { prompt_position = "bottom" },
			},
			extensions = {
				sessions_picker = {
					sessions_dir = vim.fn.stdpath("data") .. "/sessions/",
				},
				cder = {
					previewer_command = "eza "
					.. "--color=always "
					.. "-T "
					.. "--level=2 "
					.. "--icons "
					.. "--git-ignore "
					.. "--git "
					.. "--ignore-glob=.git",
					dir_command = cder_dir_cmd,
				},
				zoxide = {
					prompt_title = "Zoxide",
					verbose = false,
				},
				frecency = {
					db_safe_mode = false, -- Never ask for confirmation clean up DB
				},
			},
		})

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	end
}

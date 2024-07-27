return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-cheat.nvim" },
		{ 'nvim-telescope/telescope-fzf-native.nvim',  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
		{ "JoseConseco/telescope_sessions_picker.nvim" },
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

		-- Set custom highlight groups for Telescope
		vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = 10 })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { ctermbg = 238 })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { ctermbg = 238 })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { ctermbg = 238 })

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',
					'--line-number',
					'--column',
					'--smart-case'
				},
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
						["<C-n>"] = actions.move_selection_next,
						["<C-p>"] = actions.move_selection_previous,
						["<C-k>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.cycle_history_next,
						["<C-b>"] = actions.preview_scrolling_up,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-q>"] = actions.close,
						["<C-CR>"] = actions.to_fuzzy_refine,
					},
				},
				layout_strategy = "bottom_pane",
				results_title = "",
				border = {},
				borderchars = { '-', '|', '-', '|', '+', '+', '+', '+' },
				color_devicons = false,
				prompt_prefix = ":",
				preview = false,
				sorting_strategy = "ascending",
				layout_config = {
					bottom_pane = {
						height = 8,
						preview_cutoff = 120,
						prompt_position = "bottom"
					},
					center = {
						height = 0.4,
						preview_cutoff = 40,
						prompt_position = "top",
						width = 0.5
					},
					cursor = {
						height = 0.9,
						preview_cutoff = 40,
						width = 0.8
					},
					horizontal = {
						height = 0.9,
						preview_cutoff = 120,
						prompt_position = "bottom",
						width = 0.8
					},
					vertical = {
						height = 0.9,
						preview_cutoff = 40,
						prompt_position = "bottom",
						width = 0.8
					}
				}
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
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
					db_safe_mode = false, -- Never ask for confirmation to clean up DB
				},
			},
		})
		require('telescope').load_extension('fzf')
		require('telescope').load_extension('sessions_picker')
		require('telescope').load_extension('cder')
		require('telescope').load_extension('zoxide')
		require('telescope').load_extension('frecency')

		-- Key mappings for Telescope built-in functions
		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	end
}

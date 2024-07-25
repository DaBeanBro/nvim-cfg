return {
	"stevearc/overseer.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"rcarriga/nvim-notify",
		"stevearc/dressing.nvim",
	},
	keys = {
		{ "<leader>tb", ":OverseerBuild<cr>", desc = "Build" },
		{ "<leader>tc", ":OverseerClearCache<cr>", desc = "Clear cache" },
		{ "<leader>ti", ":OverseerInfo<cr>", desc = "Info" },
		{ "<leader>tq", ":OverseerQuickAction<cr>", desc = "Quick action" },
		{ "<leader>tr", ":OverseerRun<cr>", desc = "Run" },
		{ "<leader>td", ":OverseerRunCmd<cr>", desc = "Run Command" },
		{ "<leader>tt", ":OverseerToggle<cr>", desc = "Toggle" },
		{ "<leader>tw", ":WatchRun<cr>", desc = "Watch" },
	},

	opts = {
		component_aliases = {
			default = {
				{ "display_duration", detail_level = 2 },
				"on_output_summarize",
				"on_exit_set_status",
				"on_complete_dispose",
			},
		},
		confirm = {
			border = "rounded",
			zindex = 40,
			-- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_X and max_X can be a single value or a list of mixed integer/float types.
			min_width = 40,
			max_width = 0.5,
			width = nil,
			min_height = 6,
			max_height = 0.9,
			height = nil,
			-- Set any window options here (e.g. winhighlight)
			win_opts = {
				winblend = 0,
			},
		},
		dap = true,
		form = {
			border = "rounded",
			zindex = 40,
			-- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_X and max_X can be a single value or a list of mixed integer/float types.
			min_width = 120,
			max_width = 0.9,
			width = nil,
			min_height = 10,
			max_height = 0.9,
			height = nil,
			-- Set any window options here (e.g. winhighlight)
			win_opts = {
				winblend = 0,
			},
		},
		strategy = {
			"toggleterm",
			direction = "vertical",
			open_on_start = false,
		},
		task_list = {
			-- Default detail level for tasks. Can be 1-3.
			default_detail = 2,
			-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_width and max_width can be a single value or a list of mixed integer/float types.
			-- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
			max_width = { 100, 0.2 },
			-- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
			min_width = { 40, 0.1 },
			-- optionally define an integer/float for the exact width of the task list
			width = nil,
			max_height = { 20, 0.1 },
			min_height = 8,
			height = nil,
			-- String that separates tasks
			separator = "────────────────────────────────────────",
			-- Default direction. Can be "left", "right", or "bottom"
			direction = "right",
			-- Set keymap to false to remove default behavior
			-- You can add custom keymaps here as well (anything vim.keymap.set accepts)
			bindings = {
				["?"] = "ShowHelp",
				["g?"] = "ShowHelp",
				["<CR>"] = "RunAction",
				["<C-e>"] = "Edit",
				["o"] = "Open",
				["<C-v>"] = "OpenVsplit",
				["<C-s>"] = "OpenSplit",
				["<C-f>"] = "OpenFloat",
				["<C-q>"] = "OpenQuickFix",
				["p"] = "TogglePreview",
				["<C-l>"] = "IncreaseDetail",
				["<C-h>"] = "DecreaseDetail",
				["L"] = "IncreaseAllDetail",
				["H"] = "DecreaseAllDetail",
				["["] = "DecreaseWidth",
				["]"] = "IncreaseWidth",
				["{"] = "PrevTask",
				["}"] = "NextTask",
				["<C-k>"] = "ScrollOutputUp",
				["<C-j>"] = "ScrollOutputDown",
				["q"] = "Close",
			},
		},
		task_win = {
			win_opts = {
				winblend = 0,
			},
		},
	},
	config = function()
		require("overseer").setup({
			task_list = {
				direction = "right",
				default_detail = 2,
			},
		})

		for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/tasks/*.lua", true)) do
			loadfile(ft_path)()
		end
	end,
}

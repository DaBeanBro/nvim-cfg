return {
	"kristijanhusak/vim-dadbod-ui",
	event = "VimEnter",
	dependencies = {
		{
			"tpope/vim-dadbod",
			lazy = true,
		},
		{
			"kristijanhusak/vim-dadbod-completion",
			event = "VimEnter",
			ft = { "sql", "mysql", "plsql" },
			lazy = true,
		},
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	opts = {
		db_competion = function()
			---@diagnostic disable-next-line
			require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
		end,
	},
	config = function(_, opts)
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"sql",
			},
			command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"sql",
				"mysql",
				"plsql",
			},
			callback = function()
				vim.schedule(opts.db_completion)
			end,
		})
	end,
	keys = {
		{ "<leader>dbt", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
		{ "<leader>dbf", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
		{ "<leader>dbr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
		{ "<leader>dbq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
	},
}

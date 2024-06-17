return {
	"folke/noice.nvim",
	event = "VimEnter",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			keys = {
				{
					"<leader>un",
					function()
						require("notify").dismiss({ silent = true, pending = true })
					end,
					desc = "Dismiss all Notifications",
				},
			},
			opts = {
				timeout = 3000,
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
			},
			-- Init functions are always executed during startup
			init = function()
				vim.notify = require("notify")
			end,
		},
		keys = {
			{
				"<leader><leader>nd",
				function()
					vim.cmd("Noice dismiss")
				end,
				desc = "Dismiss visible messages",
				mode = "n",
				noremap = true,
				silent = true,
			},
		},
		opts = {
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "more lines",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "fewer lines",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "lines yanked",
					},
					opts = { skip = true },
				},
				{
					view = "split",
					filter = { event = "msg_show", min_height = 10 },
				},
			},
			cmdline = {
				view = "cmdline",
			},
			views = {
				cmdline_popup = {
					border = { style = vim.g.borderStyle },
					padding = { 2, 2 },
				},
				mini = {
					timeout = 3000,
					zindex = 10,
					position = { col = -64, row = -12 },
					format = { "{title} ", "{message}" },
				},
				hover = {
					border = { style = vim.g.borderStyle },
					size = { max_width = 80 },
					win_options = {
						scrolloff = 4,
						wrap = true,
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				popup = {
					border = { style = vim.g.borderStyle },
					size = { width = 90, height = 25 },
					win_options = { scrolloff = 8, wrap = true, concealcursor = "nv" },
					close = { keys = { "q", "<D-w>", "<D-9>", "<D-0>" } },
				},
				split = {
					enter = true,
					size = "5%",
					win_options = { scrolloff = 6 },
					close = { keys = { "q", "<D-w>", "<D-9>", "<D-0>" } },
				},
				presets = { long_message_to_split = true, lsp_doc_border = true },
				documentation = {
					opts = {
						win_options = {
							winhighlight = { FloatBorder = "DiagnosticSignInfo" },
						},
					},
				},
				lsp = {
					progress = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
			},
		},
	},
}

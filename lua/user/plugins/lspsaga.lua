return {
	"nvimdev/lspsaga.nvim",
	dependencies = {},
	event = "VeryLazy",
	config = function()
		local lspsaga = require("lspsaga")
		lspsaga.setup({ -- defaults ...
			ui = {
				code_action = "󰌶",
				diagnostic = "",
			},
			lightbulb = {
				virtual_text = false,
			},
			finder = {
				scroll_down = "<C-j>",
				scroll_up = "<C-k>", -- quit can be a table
				quit = { "q", "<ESC>" },
			},
			symbol_in_winbar = {
				enable = false,
				show_file = false,
			},
		})
		-- Import lspsaga diagnostic module
		local diagnostic = require("lspsaga.diagnostic")

		-- Key mappings for Lspsaga
		vim.keymap.set(
			"n",
			"<leader>lr",
			"<cmd>Lspsaga rename ++project<cr>",
			{ silent = true, noremap = true, desc = "Rename symbol (project-wide)" }
		)
		vim.keymap.set(
			"n",
			"M",
			"<cmd>Lspsaga code_action<cr>",
			{ silent = true, noremap = true, desc = "Code Action" }
		)
		vim.keymap.set(
			"x",
			"M",
			":<c-u>Lspsaga range_code_action<cr>",
			{ silent = true, noremap = true, desc = "Range Code Action" }
		)
		vim.keymap.set(
			"n",
			"K",
			"<cmd>Lspsaga hover_doc<cr>",
			{ silent = true, noremap = true, desc = "Hover Documentation" }
		)
		vim.keymap.set(
			"n",
			"#",
			"<cmd>Lspsaga diagnostic_jump_next<cr>",
			{ silent = true, noremap = true, desc = "Next Diagnostic" }
		)
		vim.keymap.set(
			"n",
			"*",
			"<cmd>Lspsaga diagnostic_jump_prev<cr>",
			{ silent = true, noremap = true, desc = "Previous Diagnostic" }
		)
		vim.keymap.set(
			"n",
			"<leader>lf",
			"<cmd>Lspsaga lsp_finder<CR>",
			{ silent = true, noremap = true, desc = "LSP Finder" }
		)
		vim.keymap.set(
			"n",
			"<leader>ls",
			"<cmd>Lspsaga signature_help<CR>",
			{ silent = true, noremap = true, desc = "Signature Help" }
		)
		vim.keymap.set(
			"n",
			"<leader>ld",
			"<cmd>Lspsaga preview_definition<CR>",
			{ silent = true, noremap = true, desc = "Preview Definition" }
		)
		vim.keymap.set(
			"n",
			"gd",
			"<cmd>Lspsaga peek_definition<CR>",
			{ silent = true, noremap = true, desc = "Peek Definition" }
		)
		vim.keymap.set(
			"n",
			"<leader>ll",
			"<cmd>Lspsaga show_line_diagnostics<CR>",
			{ silent = true, noremap = true, desc = "Show Line Diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>lc",
			"<cmd>Lspsaga show_cursor_diagnostics<CR>",
			{ silent = true, noremap = true, desc = "Show Cursor Diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>lb",
			"<cmd>Lspsaga show_buf_diagnostics<CR>",
			{ silent = true, noremap = true, desc = "Show Buffer Diagnostics" }
		)
		vim.keymap.set(
			"n",
			"[e",
			"<cmd>Lspsaga diagnostic_jump_prev<CR>",
			{ silent = true, noremap = true, desc = "Previous Diagnostic (alias)" }
		)
		vim.keymap.set(
			"n",
			"]e",
			"<cmd>Lspsaga diagnostic_jump_next<CR>",
			{ silent = true, noremap = true, desc = "Next Diagnostic (alias)" }
		)
		vim.keymap.set("n", "[E", function()
			diagnostic:goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end, { silent = true, noremap = true, desc = "Previous Error" })
		vim.keymap.set("n", "]E", function()
			diagnostic:goto_next({ severity = vim.diagnostic.severity.ERROR })
		end, { silent = true, noremap = true, desc = "Next Error" })
		vim.keymap.set(
			"n",
			"<leader>o",
			"<cmd>Lspsaga outline<CR>",
			{ silent = true, noremap = true, desc = "Outline" }
		)
		vim.keymap.set(
			"n",
			"<leader>li",
			"<cmd>Lspsaga incoming_calls<CR>",
			{ silent = true, noremap = true, desc = "Incoming Calls" }
		)
		vim.keymap.set(
			"n",
			"<leader>lo",
			"<cmd>Lspsaga outgoing_calls<CR>",
			{ silent = true, noremap = true, desc = "Outgoing Calls" }
		)
	end,
}

return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("todo-comments").setup({
			signs = true,
			sign_priority = 2,
			keywords = {
				FIX = {
					icon = " ",
					color = "error",
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = "", color = "info" },
				HACK = { icon = "", color = "warning" },
				WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "󰅒", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "", color = "hint", alt = { "INFO" } },
				TEST = { icon = "󰙨", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			merge_keywords = true,
			highlight = {
				before = "", -- "fg" or "bg" or empty
				keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
				after = "fg", -- "fg" or "bg" or empty
				--pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
				pattern = [[(KEYWORDS)]],
				comments_only = true,
				max_line_len = 400,
				exclude = {},
			},
			colors = {
				error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
				warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
				info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
				hint = { "LspDiagnosticsDefaultHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				-- regex that will be used to match keywords.
				-- don"t replace the (KEYWORDS) placeholder
				-- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
				pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You"ll likely get false positives
			},
		})
	end,
}

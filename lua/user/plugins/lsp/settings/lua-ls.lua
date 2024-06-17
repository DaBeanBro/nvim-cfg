return {
	on_init = function(client)
		client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
			Lua = {
				completion = { callSnippet = "Replace", autoRequire = true },
				format = {
					enable = true,
					defaultConfig = {
						indent_style = "space",
						indent_size = "2",
						max_line_length = "100",
						trailing_table_separator = "smart",
					},
				},
				diagnostics = { globals = { "vim", "it", "describe", "before_each", "are" } },
				hint = { enable = true, arrayIndex = "Disable" },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				filetypes = "lua",
			},
		})

		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		return true
	end,
}

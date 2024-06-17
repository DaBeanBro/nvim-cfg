return function()
	return {
		on_attach = function(client, _)
			if vim.tbl_contains({ "markdown", "NvimTree" }, vim.bo.filetype) then
				vim.lsp.stop_client(client.id, true)
			end
		end,
		settings = {
			typos_lsp = {
				init_options = {
					diagnosticSeverity = "info",
				},
			},
		},
	}
end

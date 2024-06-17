return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "off",
				},
			},
		},
	}
end

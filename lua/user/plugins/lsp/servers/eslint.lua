local util = require("lspconfig.util")
return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		settings = {
			eslint = {
				format = {
					enable = true,
				},
				rules = {
					customizations = {
						-- Your Rules
					},
				},
			},
			root_dir = util.find_git_ancestor,
		},
	}
end

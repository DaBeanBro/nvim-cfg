return {
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(client, bufnr)
			lsp_zero.default_keymaps({ buffer = bufnr })
			print("LSP attached to buffer: " .. bufnr) -- Debug information
		end)

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = lsp_zero.on_attach,
					})
				end,
			},
		})
	end,
}

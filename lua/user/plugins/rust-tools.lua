return {
	"simrat39/rust-tools.nvim",
	dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
	ft = { "rust" },
	config = function()
		local rust_tools = {}

		function rust_tools.setup()
			local mason_registry = require("mason-registry")

			local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
			local codelldb_path = codelldb_root .. "adapter/codelldb"
			local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

			local cfg = require("rustaceanvim.config")
			vim.g.rustaceanvim = {
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
				inlay_hints = {
					highlight = "NonText",
				},
				tools = {
					hover_actions = {
						auto_focus = true,
					},
				},
				server = {
					on_attach = function(client, bufnr)
						require("user.plugins.lsp-inlay-hints").on_attach(client, bufnr)
						vim.lsp.inlay_hint(bufnr, true)
					end,
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			}
		end

		return rust_tools
	end,
}

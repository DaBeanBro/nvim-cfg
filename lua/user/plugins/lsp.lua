return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		local mason_path = require("mason-core.path")
		local get_install_path = require("utils").get_install_path

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			ltex = {
				filetypes = { "markdown", "md", "tex", "text" },
				flags = { debounce_text_changes = 300 },
				settings = {
					ltex = {
						language = "en",
						setenceCacheSize = 2000,
						additionalRules = {
							enablePickyRules = true,
							motherTongue = "en",
						},
						trace = { server = "verbose" },
						disabledRules = {},
						hiddenFalsePositives = {},
						username = "x@y.z",
						apiKey = "tete",
					},
				},
			},
			lua_ls = {
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
				on_attach = function() end,
			},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = { url = "https://www.schemastore.org/api/json/catalog.json", enable = true },
						customTags = {
							"!Equals sequence",
							"!FindInMap sequence",
							"!GetAtt",
							"!GetAZs",
							"!ImportValue",
							"!Join sequence",
							"!Ref",
							"!Select sequence",
							"!Split sequence",
							"!Sub",
							"!Or sequence",
						},
					},
				},
			},
			eslint = {
				on_attach = function(_, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			},
			bashls = { filetypes = { "sh", "zsh" } },
			emmet_ls = {
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				filetypes = { "html", "css", "typescript", "javascript" },
			},
			jsonls = {
				settings = {
					json = {
						validate = { enable = true },
					},
				},
			},
			bicep = { cmd = { mason_path.concat({ get_install_path("bicep-lsp"), "bicep-lsp" }) } },
			typst_lsp = {
				on_attach = function() end,
			},
			typos_lsp = {
				on_attach = function(client, _)
					if vim.tbl_contains({ "markdown", "NvimTree" }, vim.bo.filetype) then
						vim.lsp.stop_client(client.id, true)
					end
				end,
				init_options = {
					diagnosticSeverity = "hint",
					config = vim.env.HOME .. "/.typos.toml",
				},
			},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pylint = { enabled = false },
							pycodestyle = { enabled = false },
						},
					},
				},
			},
			clangd = {
				settings = {
					clangd = {
						cmd = { "clangd", "--offset-encoding=utf-16" },
					},
				},
			},
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

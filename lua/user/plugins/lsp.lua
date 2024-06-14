return {
	{
		"VonHeikemen/lsp-zero.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd("MasonUpdate"))
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Integration with nvim-lspconfig
			{ "b0o/schemastore.nvim" }, -- YAML/JSON schemas
			{ "jose-elias-alvarez/typescript.nvim" }, -- TypeScript utilities
			{ "davidosomething/format-ts-errors.nvim" }, -- Prettier TypeScript errors

			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "SmiteshP/nvim-navic" },
			{ "lvimuser/lsp-inlayhints.nvim" }, -- Inlay hints
			{ "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },
		},
		config = function()
			local api, lsp, diagnostic = vim.api, vim.lsp, vim.diagnostic
			local lspconfig = require("lspconfig")
			local telescope = require("telescope.builtin")
			local mason_path = require("mason-core.path")
			local typescript = require("typescript")
			local get_install_path = require("utils").get_install_path

			local function map(modes, lhs, rhs, opts)
				if type(opts) == "string" then
					opts = { desc = opts }
				elseif not opts then
					opts = {}
				end
				opts = vim.tbl_extend("keep", opts, { buffer = true })
				require("utils").map(modes, lhs, rhs, opts)
			end

			local function map_vsplit(lhs, fn, description)
				vim.keymap.set("n", lhs, function()
					require("telescope.builtin")[fn]({ jump_type = "vsplit" })
				end, { desc = description })
			end

			local function typescript_organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "Organize imports",
				}
				vim.lsp.buf.execute_command(params)
			end

			-- TypeScript server configuration
			local tsserver_config = {
				on_attach = function()
					local actions = typescript.actions

					local function spread(char)
						return function()
							require("utils").feedkeys("siw" .. char .. "a...<Esc>2%i, ", "m")
						end
					end

					local function rename_file()
						local workspace_path = lsp.buf.list_workspace_folders()[1]
						local file_path = vim.fn.expand("%:" .. workspace_path .. ":.")
						vim.ui.input({ prompt = "Rename file", default = file_path }, function(target)
							if target then
								typescript.renameFile(file_path, target)
							end
						end)
					end

					map("n", "<leader>lo", "<cmd>TypescriptOrganizeAndFixImports<CR>", "LSP Organize imports")
					map("n", "<leader>li", actions.addMissingImports, "LSP add missing imports")
					map("n", "<leader>lf", actions.fixAll, "LSP fix all errors")
					map("n", "<leader>lu", actions.removeUnused, "LSP remove unused")
					map("n", "<leader>lr", rename_file, "LSP rename file")
					map("n", "<leader>lc", function()
						require("tsc").run()
					end, "Type check project")
					map("n", "<leader>ls", spread("{"), { remap = true, desc = "Spread object under cursor" })
					map("n", "<leader>lS", spread("["), { remap = true, desc = "Spread array under cursor" })
				end,
				commands = {
					TypescriptOrganizeAndFixImports = {
						typescript_organize_imports,
						description = "Organize imports",
					},
				},
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayEnumMemberValueHints = true,
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = false,
							includeInlayVariableTypeHints = false,
							includeInlayVariableTypeHintsWhenTypeMatchesName = false,
							includeInlayFunctionLikeReturnTypeHints = false,
						},
					},
				},
				handlers = {
					["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
						if not result.diagnostics then
							return
						end

						local idx = 1
						while idx <= #result.diagnostics do
							local entry = result.diagnostics[idx]
							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message
							if entry.code == 80001 then
								table.remove(result.diagnostics, idx)
							else
								idx = idx + 1
							end
						end

						lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
					end,
				},
			}

			-- Server configurations
			local server_configs = {
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
							},
						})

						client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						return true
					end,
					on_attach = function()
						map("n", "<leader>lt", "<Plug>PlenaryTestFile", "Run file's plenary tests")
					end,
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
						api.nvim_create_autocmd("BufWritePre", {
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
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				bicep = { cmd = { mason_path.concat({ get_install_path("bicep-lsp"), "bicep-lsp" }) } },
				typst_lsp = {
					on_attach = function()
						map("n", "<leader>lw", "<cmd>TypstWatch<CR>", "Watch file")
					end,
				},
				typos_lsp = {
					on_attach = function(client, _)
						if vim.tbl_contains({ "markdown", "NvimTree" }, vim.bo.filetype) then
							vim.lsp.stop_client(client.id, true)
						end
					end,
					init_options = {
						diagnosticSeverity = "info",
						config = vim.env.HOME .. "/.typos.toml",
					},
					filetypes = { "latex", "textDocument", "markdown" },
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

			local disable = function() end
			local special_server_configs = {
				tsserver = function()
					typescript.setup({ server = tsserver_config })
				end,
				zk = disable,
				rust_analyzer = disable,
				jdtls = disable,
				ltex = disable,
				gopls = disable,
			}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Set up servers
			local function setup(server_name)
				local special_server_setup = special_server_configs[server_name]
				if special_server_setup then
					special_server_setup()
					return
				end

				local opts = server_configs[server_name] or {}
				local opts_with_capabilities = vim.tbl_deep_extend("force", opts, { capabilities = capabilities })
				lspconfig[server_name].setup(opts_with_capabilities)
			end

			local ensure_installed = vim.list_extend(vim.tbl_keys(server_configs), vim.tbl_keys(special_server_configs))

			require("mason-lspconfig").setup({
				handlers = { setup },
				ensure_installed = ensure_installed,
			})

			-- Mason setup
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Enable LSP inlay hints
			require("lsp-inlayhints").setup()

			-- Custom diagnostic settings
			diagnostic.config({
				virtual_text = false,
				signs = true,
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "",
				},
			})

			-- Custom keymaps for LSP functionality
			map("n", "gd", function()
				telescope.lsp_definitions()
			end, "Goto definition")
			map("n", "gD", lsp.buf.declaration, "Goto declaration")
			map("n", "gi", function()
				telescope.lsp_implementations()
			end, "Goto implementation")
			map("n", "go", function()
				telescope.lsp_type_definitions()
			end, "Goto type definition")
			map("n", "gr", function()
				telescope.lsp_references()
			end, "Goto references")
			map("n", "K", lsp.buf.hover, "Hover documentation")
			map("n", "<C-k>", lsp.buf.signature_help, "Signature help")
			map("n", "<leader>lr", lsp.buf.rename, "Rename symbol")
			map("n", "<leader>la", lsp.buf.code_action, "Code action")
			map("n", "<leader>ld", function()
				diagnostic.open_float()
			end, "Show diagnostics")
			map("n", "[d", function()
				diagnostic.goto_prev()
			end, "Previous diagnostic")
			map("n", "]d", function()
				diagnostic.goto_next()
			end, "Next diagnostic")

			-- Additional keymaps for file-specific operations
			map_vsplit("<leader>lv", "lsp_definitions", "Goto definition in vsplit")
			map_vsplit("<leader>lt", "lsp_type_definitions", "Goto type definition in vsplit")
			map_vsplit("<leader>li", "lsp_implementations", "Goto implementation in vsplit")
			map_vsplit("<leader>lr", "lsp_references", "Goto references in vsplit")
		end,
	},
}

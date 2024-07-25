return {
	"neovim/nvim-lspconfig",
	enabled = true,
	dependencies = {
		"williamboman/mason.nvim", -- For installing LSP servers
		"williamboman/mason-lspconfig.nvim", -- Integration with nvim-lspconfig
		"b0o/schemastore.nvim", -- YAML/JSON schemas
		"jose-elias-alvarez/typescript.nvim", -- TypeScript utilities
		"davidosomething/format-ts-errors.nvim", -- Prettier TypeScript errors
		"hrsh7th/cmp-nvim-lsp", -- Improved LSP capabilities
		"lvimuser/lsp-inlayhints.nvim", -- Inlay hints
		"onsails/lspkind.nvim",
		"nvimdev/lspsaga.nvim",
		"nvim-lua/lsp-status.nvim",
		{
			"ray-x/lsp_signature.nvim",
			event = "VeryLazy",
			opts = {},
			config = function(_, opts)
				require("lsp_signature").setup(opts)
			end,
		},
		{ "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },
	},
	event = { "VeryLazy", "BufWrite" },
	init = function()
		vim.keymap.set("n", "<leader>lf", "<cmd>Format<cr>", { desc = "LSP | Format", silent = true })
		vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP | Info", silent = true })
		vim.keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "LSP | Restart", silent = true })

		vim.keymap.set("v", "<leader>lf", "<cmd>Format<cr>", { desc = "LSP | Format", silent = true })

		vim.keymap.set("n", "<leader>lh", function()
			if vim.fn.has("nvim-0.10") == 1 then
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end
		end, { desc = "LSP | Toggle Inlay Hints", silent = true })
	end,
	cmd = "LspInfo",
	config = function()
		local lspconfig = require("lspconfig")
		local lsp_status = require("lsp-status")
		local lspkind = require("lspkind")
		local lsp = vim.lsp

		local config = {
			-- Enable virtual text
			virtual_text = true,
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}

		local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }

		if vim.fn.has("nvim-0.11") == 1 then
			config.signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
				linehl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
			}
		else
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			config.signs = { active = signs }
		end

		vim.diagnostic.config(config)

		local kind_symbols = {
			Text = "",
			Method = "Ƒ",
			Function = "ƒ",
			Constructor = "",
			Variable = "",
			Class = "",
			Interface = "ﰮ",
			Module = "",
			Property = "",
			Unit = "",
			Value = "",
			Enum = "了",
			Keyword = "",
			Snippet = "﬌",
			Color = "",
			File = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "",
		}

		lsp_status.config({
			kind_labels = kind_symbols,
			select_symbol = function(cursor_pos, symbol)
				if symbol.valueRange then
					local value_range = {
						["start"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
						["end"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
					}

					return require("lsp-status/util").in_range(cursor_pos, value_range)
				end
			end,
			current_function = true,
		})

		lsp_status.register_progress()
		lspkind.init({ symbol_map = kind_symbols })
		local function on_attach(client, bufnr)
			local function buf_keymap(...)
				vim.api.nvim_buf_set_keymap(bufnr, ...)
			end
			local function buf_set_option(...)
				vim.api.nvim_buf_set_option(bufnr, ...)
			end

			buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

			-- Mappings.
			local opts = { noremap = true, silent = true }
			buf_keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			buf_keymap("n", "<leader>lt", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			buf_keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			buf_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			buf_keymap("n", "<leader>ld", '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
			buf_keymap("n", "<leader>ln", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
			buf_keymap("n", "<leader>lp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
			buf_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
			buf_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
			buf_keymap("n", "<leader>ls", '<cmd>lua require("lspsaga.signaturehelp").signature_help()<cr>', opts)
			buf_keymap("n", "<leader>ll", '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<cr>', opts)
			buf_keymap("n", "<leader>m", '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
			-- buf_keymap("n", "<leader>M", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			-- buf_keymap("v", "<leader>a", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", opts)
			buf_keymap("v", "<leader>m", ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
			buf_keymap("n", "<leader>r", '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)

			-- scroll down hover doc or scroll in definition preview
			buf_keymap("n", "<C-f>", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
			-- scroll up hover doc
			buf_keymap("n", "<C-b>", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

			-- Set some keybinds conditional on server capabilities
			if client.server_capabilities.document_formatting then
				buf_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
			end
			if client.server_capabilities.document_range_formatting then
				buf_keymap("v", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<cr>", opts)
			end

			lsp_status.on_attach(client, bufnr)
		end

		local presentCmpNvimLsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, config)

		local border = {
			border = "shadow",
		}

		local capabilities
		if presentCmpNvimLsp then
			capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
		else
			capabilities = vim.lsp.protocol.make_client_capabilities()
		end

		local servers = {
			bashls = require("user.plugins.lsp.servers.bashls")(on_attach),
			clangd = require("user.plugins.lsp.servers.clangd")(on_attach),
			cssls = require("user.plugins.lsp.servers.cssls")(on_attach),
			elixirls = require("user.plugins.lsp.servers.elixir-ls")(on_attach),
			eslint = require("user.plugins.lsp.servers.eslint")(on_attach),
			dockerls = {},
			html = {},
			gopls = require("user.plugins.lsp.servers.gopls")(on_attach),
			jsonls = require("user.plugins.lsp.servers.jsonls")(on_attach),
			lua_ls = require("user.plugins.lsp.servers.lua-ls")(on_attach),
			intelephense = {},
			pylsp = require("user.plugins.lsp.servers.pyright")(on_attach),
			tailwindcss = require("user.plugins.lsp.servers.tailwindcss")(on_attach),
			terraformls = {},
			tflint = {},
			tsserver = require("user.plugins.lsp.servers.tsserver")(on_attach),
			yamlls = {},
			-- typos_lsp = require("user.plugins.lsp.servers.typos_lsp")(on_attach),
		}

		local default_lsp_config = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 200,
				allow_incremental_sync = true,
			},
		}

		local server_names = {}
		for server_name, _ in pairs(servers) do
			table.insert(server_names, server_name)
		end

		local present_mason, mason = pcall(require, "mason-lspconfig")
		if present_mason then
			mason.setup({ ensure_installed = server_names })
		end

		for server_name, server_config in pairs(servers) do
			local merged_config = vim.tbl_deep_extend("force", default_lsp_config, server_config)
			lspconfig[server_name].setup(merged_config)

			if server_name == "rust_analyzer" then
				local present_rust_tools, rust_tools = pcall(require, "rust-tools")
				if present_rust_tools then
					rust_tools.setup({ server = merged_config })
				end
			end
		end
	end,
}

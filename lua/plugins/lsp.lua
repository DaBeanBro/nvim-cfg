return {
	"williamboman/mason.nvim",
	event = "User FilePost",
	dependencies = {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		dependencies = {
			"neovim/nvim-lspconfig",
			enabled = true,
			dependencies = {
				"williamboman/mason.nvim",           -- For installing LSP servers
				"williamboman/mason-lspconfig.nvim", -- Integration with nvim-lspconfig
				"b0o/schemastore.nvim",              -- YAML/JSON schemas
				"jose-elias-alvarez/typescript.nvim", -- TypeScript utilities
				"davidosomething/format-ts-errors.nvim", -- Prettier TypeScript errors
				"hrsh7th/cmp-nvim-lsp",              -- Improved LSP capabilities
				"lvimuser/lsp-inlayhints.nvim",      -- Inlay hints
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
		},
		event = "VeryLazy",
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local path = require "mason-core.path"
			local mason_lspconfig = require("mason-lspconfig")
			local lsp_zero = require('lsp-zero')

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			lsp_zero.set_sign_icons({
				error = '✘',
				warn = '▲',
				hint = '⚑',
				info = '»'
			})

			lspconfig.sourcekit.setup({
				cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
				filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
				root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
			})


			mason.setup({
				ui = {
					check_outdated_packages_on_open = false,
					icons = {
						package_pending = " ",
						package_installed = " ",
						package_uninstalled = " ",
					},
				},
				install_root_dir = path.concat { vim.fn.stdpath "config", "/lua/core/mason" },
			})

			local disabled_servers = {
				-- "jdtls",
				-- "rust_analyzer",
				"typos-lsp",
				-- "tsserver",
			}

			mason_lspconfig.setup({
				automatic_installation = true,
				ensure_installed = {
					-- Lua
					"lua_ls",
					-- "vimls",

					-- Web Development
					-- "cssls",
					-- "html",
					-- "tsserver",
					-- "denols",
					-- "vuels",
					-- "tailwindcss",
					-- "emmet_language_server",
					-- "eslint-lsp",

					-- PHP
					-- "intelephense",

					-- C/C++
					-- "clangd",

					-- CMake
					-- "neocmake",

					-- Java
					-- "jdtls",

					-- Yaml
					-- "yamlls",

					-- Python
					-- "pyright",

					-- Go
					-- "gopls",

					-- C#
					-- "omnisharp",
					-- "omnisharp-mono",
				},
				handlers = {
					function(server_name)
						for _, name in pairs(disabled_servers) do
							if name == server_name then
								return
							end
						end

						lspconfig[server_name].setup({})
					end,
				}
			})
		end
	},
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonInstallAll",
		"MasonUpdate",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
	},
	opts = {
		registries = {
			"github:nvim-java/mason-registry",
			"github:mason-org/mason-registry",
		},
	},
}

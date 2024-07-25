return {
	"rcarriga/nvim-dap-ui",
	requires = { "mfussenegger/nvim-dap" },
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "»" },
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						"scopes",
						-- 'breakpoints',
						"stacks",
						-- 'watches',
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						"repl",
						--    'console',
					},
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "rounded", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			controls = {
				-- Requires Neovim nightly (or 0.8 when released)
				enabled = false, -- because the icons don't work
				-- Display controls in this element
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "",
					terminate = "",
				},
			},
			windows = { indent = 1 },
		})

		-- add listeners to auto open DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		vim.keymap.set("n", "<leader>db", function()
			require("dap").toggle_breakpoint()
		end, { desc = "Toggle Breakpoints" })
		vim.keymap.set("n", "<leader>dB", function()
			require("dap").clear_breakpoints()
		end, { desc = "Clear Breakpoints" })
		vim.keymap.set("n", "<leader>dc", function()
			require("dap").continue()
		end, { desc = "Continue" })
		vim.keymap.set("n", "<F5>", function()
			require("dap").continue()
		end, { desc = "Continue2" })
		vim.keymap.set("n", "<leader>di", function()
			require("dap").step_into()
		end, { desc = "Step Into" })
		vim.keymap.set("n", "<F3>", function()
			require("dap").step_into()
		end, { desc = "Step Into2" })
		vim.keymap.set("n", "<leader>dl", function()
			require("dapui").float_element("breakpoints")
		end, { desc = "List Breakpoints" })
		vim.keymap.set("n", "<leader>do", function()
			require("dap").step_over()
		end, { desc = "Step Over" })
		vim.keymap.set("n", "<F2>", function()
			require("dap").step_over()
		end, { desc = "Step Over2 " })
		vim.keymap.set("n", "<leader>dO", function()
			require("dap").step_out()
		end, { desc = "Step Out" })
		vim.keymap.set("n", "<F4>", function()
			require("dap").step_out()
		end, { desc = "Step Out2" })
		-- gives error, but docs say it's ok?
		-- vim.keymap.set("n", { "<leader>dq", "<F7>" }, function()
		-- 	require("dap").close()
		-- 	dapui.close()
		-- end, { desc = "Close Session" })
		vim.keymap.set("n", "<leader>dq", function()
			require("dap").close()
			dapui.close()
		end, { desc = "Close Session" })
		vim.keymap.set("n", "<F7>", function()
			require("dap").close()
			dapui.close()
		end, { desc = "Close Session" })

		vim.keymap.set("n", "<leader>dQ", function()
			dap = require("dap")
			dap.terminate()
			dap.close()
			dapui.close()
		end)
		vim.keymap.set("n", "<F6>", function()
			dap = require("dap")
			dap.terminate()
			dap.close()
			dapui.close()
		end, { desc = "Terminate" })

		vim.keymap.set("n", "<leader>dr", function()
			require("dap").repl.toggle()
		end, { desc = "REPL" })
		vim.keymap.set("n", "<leader>ds", function()
			require("dapui").float_element("scopes")
		end, { desc = "Scopes" })
		vim.keymap.set("n", "<leader>dt", function()
			require("dapui").float_element("stacks")
		end, { desc = "Threads" })
		vim.keymap.set("n", "<leader>du", function()
			require("dapui").toggle()
		end, { desc = "Toggle Debugger UI" })
		vim.keymap.set("n", "<leader>dw", function()
			require("dapui").float_element("watches")
		end, { desc = "Watches" })
		vim.keymap.set("n", "<leader>dx", function()
			require("dap.ui.widgets").hover()
		end, { desc = "Inspect" })
	end,
}

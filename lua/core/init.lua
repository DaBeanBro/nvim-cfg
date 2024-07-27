local colors = "catppuccin-mocha"
local background = "dark"

local load_colors = function()
	vim.api.nvim_command("colorscheme " .. colors)
	vim.api.nvim_command("set background=" .. background)
end

local load_leader = function()
	vim.g.mapleader = " "
	vim.g.localleader = " "
end

local load_core = function()
	load_leader()
	require("core.defaultmap")
	require("core.options")
	require("core.lazy")

	load_colors()
	vim.api.nvim_set_hl(0, "Cursor", { fg = "#77DD77", bg = "#66DD66" })
	vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#99ff99', bg = '' })
	vim.opt.guicursor = "a:block-Cursor"
end

load_core()

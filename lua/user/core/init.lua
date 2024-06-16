-- -- -- -- --
--   Core   --
-- -- -- -- --
local load = require("utils").load
local settings = load("user.core.settings")

local diagnostics = function()
	-----------------
	-- Diagnostics --
	-----------------
	local function sign_define(name, symbol)
		vim.fn.sign_define(name, {
			text = symbol,
			texthl = name,
		})
	end

	sign_define("DiagnosticSignError", "")
	sign_define("DiagnosticSignWarn", "")
	sign_define("DiagnosticSignHint", "")
	sign_define("DiagnosticSignInfo", "")
end

local function neovide_config()
	if vim.g.neovide then
		local nvide_o = {
			neovide_no_idle = true,
			neovide_show_border = true,
			neovide_refresh_rate = 120,
			neovide_cursor_vfx_mode = "torpedo",
			neovide_cursor_vfx_opacity = 200.0,
			neovide_cursor_antialiasing = true,
			neovide_cursor_trail_length = 0.05,
			neovide_cursor_animation_length = 0.03,
			neovide_cursor_vfx_particle_speed = 20.0,
			neovide_cursor_vfx_particle_density = 5.0,
			neovide_cursor_vfx_particle_lifetime = 1.2,
		}
		for opt, val in pairs(nvide_o) do
			vim.g[opt] = val
		end
	end
end

local cmake = function()
	local api = vim.api

	-- Define a function to set the filetype to cmake for CMakeLists.txt
	local function set_cmake_filetype()
		vim.bo.filetype = "cmake"
	end

	-- Set up an autocmd for BufNewFile and BufRead events on CMakeLists.txt
	api.nvim_command("autocmd BufNewFile,BufRead CMakeLists.txt set filetype=cmake")
end

local conflict = function()
	-- Do not load native syntax completion
	vim.g.loaded_syntax_completion = 1

	-- Do not load spell files
	vim.g.loaded_spellfile_plugin = 1

	-- Whether to load netrw by default
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwFileHandlers = 1
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_netrwSettings = 1
	-- newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
	vim.g.netrw_liststyle = 3

	-- Do not load tohtml.vim
	vim.g.loaded_2html_plugin = 1

	-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all of these plugins are
	-- related to reading files inside compressed containers)
	vim.g.loaded_gzip = 1
	vim.g.loaded_tar = 1
	vim.g.loaded_tarPlugin = 1
	vim.g.loaded_vimball = 1
	vim.g.loaded_vimballPlugin = 1
	vim.g.loaded_zip = 1
	vim.g.loaded_zipPlugin = 1

	-- Do not use builtin matchit.vim and matchparen.vim because we're using vim-matchup
	vim.g.loaded_matchit = 1
	vim.g.loaded_matchparen = 1

	-- Disable sql omni completion
	vim.g.loaded_sql_completion = 1

	-- Set this to 0 in order to disable native EditorConfig support
	vim.g.editorconfig = 1

	-- Disable remote plugins
	-- NOTE:
	--  > Disabling rplugin.vim will make `wilder.nvim` complain about missing rplugins during :checkhealth,
	--  > but since it's config doesn't require python rtp (strictly), it's fine to ignore that for now.
	-- vim.g.loaded_remote_plugins = 1
end

local map_leader = function()
	vim.g.mapleader = ","
end

local load_core = function()
	cmake()
	conflict()
	map_leader()
	neovide_config()
	load("user.core.default_keymaps")
	load("user.core.options")
	load("user.core.lazy")
	diagnostics()
	load("user.core.mappings")
	-- diagnostics()

	-- Colorscheme
	local colors = settings.colorscheme
	local bg = settings.background

	vim.api.nvim_command("colorscheme " .. colors)
	vim.api.nvim_command("set background=" .. bg)
end

load_core()

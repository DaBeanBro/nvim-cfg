local M = {}

---runs :normal with bang
---@param cmdStr string
function M.normal(cmdStr)
	vim.cmd.normal({ cmdStr, bang = true })
end

---@nodiscard
---@param path string
function M.fileExists(path)
	return vim.uv.fs_stat(path) ~= nil
end

---@param msg string
---@param title string
---@param level? "info"|"trace"|"debug"|"warn"|"error"
function M.notify(title, msg, level)
	if not level then
		level = "info"
	end
	vim.notify(msg, vim.log.levels[level:upper()], { title = title })
end

function M.copyAndNotify(text)
	vim.fn.setreg("+", text)
	vim.notify(text, vim.log.levels.INFO, { title = "Copied" })
end

---@param hlName string name of highlight group
---@param key "fg"|"bg"|"bold"
---@nodiscard
---@return string|nil the value, or nil if hlgroup or key is not available
function M.getHighlightValue(hlName, key)
	local hl
	repeat
		-- follow linked highlights
		hl = vim.api.nvim_get_hl(0, { name = hlName })
		hlName = hl.link
	until not hl.link
	local value = hl[key]
	if value then
		return ("#%06x"):format(value)
	else
		local msg = ("No %s available for highlight group %q"):format(key, hlName)
		M.notify("getHighlightValue", msg, "warn")
	end
end

function M.leaveVisualMode()
	local escKey = vim.api.nvim_replace_termcodes("<Esc>", false, true, true)
	vim.api.nvim_feedkeys(escKey, "nx", false)
end

--------------------------------------------------------------------------------

---Creates autocommand triggered by Colorscheme change, that modifies a
---highlight group. Mostly useful for setting up colorscheme modifications
---specific to plugins, that should persist across colorscheme changes triggered
---by switching between dark and light mode.
---@param hlgroup string
---@param modification table
function M.colorschemeMod(hlgroup, modification)
	vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
		callback = function()
			vim.api.nvim_set_hl(0, hlgroup, modification)
		end,
	})
end

---set up subkey for the <leader> key (if whichkey is loaded)
---@param key string
---@param label string
---@param modes string|string[]
function M.leaderSubkey(key, label, modes)
	vim.defer_fn(function()
		local ok, whichkey = pcall(require, "which-key")
		if not ok then
			return
		end
		whichkey.register({ [key] = { name = " " .. label } }, { prefix = "<leader>", mode = modes or "n" })
	end, 1500)
end

---Adds a component to the lualine after lualine was already set up. Useful for
---lazyloading.
---@param whichBar "tabline"|"winbar"|"inactive_winbar"|"sections"
---@param whichSection "lualine_a"|"lualine_b"|"lualine_c"|"lualine_x"|"lualine_y"|"lualine_z"
---@param component function|table the component forming the lualine
---@param whereInSection? "before"|"after"
function M.addToLuaLine(whichBar, whichSection, component, whereInSection)
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return
	end
	local sectionConfig = lualine.get_config()[whichBar][whichSection] or {}

	local componentObj = type(component) == "table" and component or { component }
	if whereInSection == "before" then
		table.insert(sectionConfig, 1, componentObj)
	else
		table.insert(sectionConfig, componentObj)
	end
	lualine.setup({ [whichBar] = { [whichSection] = sectionConfig } })

	-- Theming needs to be re-applied, since the lualine-styling can change
	require("config.theme-customization").themeModifications()
end

---ensures unique keymaps https://www.reddit.com/r/neovim/comments/16h2lla/can_you_make_neovim_warn_you_if_your_config_maps/
---@param modes string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? { unique: boolean, desc: string, buffer: boolean|number, nowait: boolean, remap: boolean }
function M.uniqueKeymap(modes, lhs, rhs, opts)
	if not opts then
		opts = {}
	end
	if opts.unique == nil then
		opts.unique = true
	end
	vim.keymap.set(modes, lhs, rhs, opts)
end

--------------------------------------------------------------------------------

M.textobjRemaps = {
	c = "}", -- [c]urly brace
	r = "]", -- [r]ectangular bracket
	m = "W", -- [m]assive word
	q = '"', -- [q]uote
	z = "'", -- [z]ingle quote
	e = "`", -- t[e]mplate string / inline cod[e]
}
M.extraTextobjMaps = {
	func = "f",
	call = "l",
	wikilink = "R",
	condition = "o",
}

--------------------------------------------------------------------------------

M.load = function(mod)
	if type(mod) ~= "string" then
		vim.api.nvim_err_writeln("Module name must be a string")
		return nil
	end

	package.loaded[mod] = nil
	local status, result = pcall(require, mod)
	if not status then
		vim.api.nvim_err_writeln("Error loading module " .. mod .. ": " .. result)
		return nil
	end

	return result
end

function M.termcodes(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.map(modes, lhs, rhs, opts)
	if type(opts) == "string" then
		opts = { desc = opts }
	end
	local options = vim.tbl_extend("keep", opts or {}, { silent = true })
	vim.keymap.set(modes, lhs, rhs, options)
end

function M.local_map(buffer)
	return function(modes, lhs, rhs, opts)
		if type(opts) == "string" then
			opts = { desc = opts, buffer = buffer }
		end
		local options = vim.tbl_extend("keep", opts or {}, { silent = true })

		vim.keymap.set(modes, lhs, rhs, options)
	end
end

function M.feedkeys(keys, mode)
	if mode == nil then
		mode = "in"
	end
	return vim.api.nvim_feedkeys(M.termcodes(keys), mode, true)
end

function M.feedkeys_count(keys, mode)
	return M.feedkeys(vim.v.count1 .. keys, mode)
end

function M.error(message)
	vim.api.nvim_echo({ { message, "Error" } }, false, {})
end

--- Returns a new table with `element` appended to `tbl`
function M.append(tbl, element)
	local new_table = vim.deepcopy(tbl)
	table.insert(new_table, element)
	return new_table
end

--- Gets the buffer number of every visible buffer
--- @return integer[]
function M.visible_buffers()
	return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
end

local function lsp_server_has_references()
	return vim.tbl_contains(vim.lsp.get_clients(), function(client)
		local capabilities = client.server_capabilities
		return capabilities and capabilities.referencesProvider
	end, { predicate = true })
end

--- Clear all highlighted LSP references in all windows
function M.clear_lsp_references()
	vim.cmd.nohlsearch()
	if lsp_server_has_references() then
		vim.lsp.buf.clear_references()
		for _, buffer in pairs(M.visible_buffers()) do
			vim.lsp.util.buf_clear_references(buffer)
		end
	end
end

--- Get Mason package install path
function M.get_install_path(package)
	return require("mason-registry").get_package(package):get_install_path()
end

-- Import plugin config from external module in `lua/configs/`
function M.use(module)
	local ok, m = pcall(require, string.format("configs.%s", module))
	if ok then
		return m
	else
		vim.notify(string.format("Failed to import Lazy config module %s: %s", module, m))
		return {}
	end
end

-- Check if noice is loaded and running
function M.noice_is_loaded()
	local success, _ = pcall(require, "noice.config")
	return success and require("noice.config")._running
end

-- Check if a specific plugin is loaded using lazy.nvim
function M.plugin_is_loaded(plugin)
	-- Checking with `require` and `pcall` will cause Lazy to load the plugin
	local plugins = require("lazy.core.config").plugins
	return not not plugins[plugin] and plugins[plugin]._.loaded
end

return M

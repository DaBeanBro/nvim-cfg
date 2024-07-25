return {
	"nvim-lualine/lualine.nvim",
	dependencies = { 'nvim-tree/nvim-web-devicons', 'arkav/lualine-lsp-progress', 'letieu/harpoon-lualine' },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local function current_lsp()
			local lsp_info = {}

			for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
				table.insert(lsp_info, client.name)
			end

			return table.concat(lsp_info, '|')
		end

		lualine.setup {
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {
					'branch',
					'diff',
					{ 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } },
				},
				lualine_c = {
					{ 'harpoon2', no_harpoon = '' },
					{ 'filename', path = 1 },
					-- {
					--   require("nvim-possession").status,
					--   cond = function()
					--     return require("nvim-possession").status() ~= nil
					--   end,
					-- },
				},
				lualine_x = {
					current_lsp,
					'lsp_progress',
					'encoding',
					'fileformat',
					'filetype',
					-- lazy_status.updates,
					-- cond = lazy_status.has_updates,
				},
				lualine_y = { 'progress' },
				lualine_z = { 'location', 'selectioncount' },
			},
		}
	end,
}

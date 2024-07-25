local M = {
	"lethc/bracey.vim",
	build = "npm install --prefix server",
	dependencies = {
		{
			"barrett-ruth/live-server.nvim",
			build = "pnpm add -g live-server",
			event = "VimEnter",
			cmd = { "LiveServerStart", "LiveServerStop" },
			config = true,
		},
		"ray-x/web-tools.nvim",
	},
}

function M.config()
	require("live-server").setup()
	require("web-tools").setup()
end

return M

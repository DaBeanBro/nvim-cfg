return {
	"barrett-ruth/live-server.nvim",
	build = "pnpm add -g live-server",
	event = "VimEnter",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = true,
}

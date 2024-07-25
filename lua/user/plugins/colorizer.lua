return {
	"norcalli/nvim-colorizer.lua",
	event = "VimEnter",
	enabled = true,
	lazy = true,
	cmd = {
		"ColorizerToggle",
		"ColorizerAttachToBuffer",
		"ColorizerDetachFromBuffer",
		"ColorizerReloadAllBuffers",
	},
}

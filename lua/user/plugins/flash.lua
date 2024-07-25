return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		labels = "asdfghjkl;vnryrueiwo",
		search = {
			multi_window = false,
		},
		label = {
			uppercase = false,
		},
		modes = {
			search = {
				enabled = true,
			},
			char = {
				enabled = true,
				highlight = { backdrop = false },
				multi_line = false,
			},
			remote = {
				highlight = { backdrop = false },
				remote_op = { restore = true, motion = true },
			},
		},
		prompt = {
			enabled = false,
		},
	},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}

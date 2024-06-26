return { -- Foldtext customization in Neovim
	"anuvyklack/pretty-fold.nvim",
	event = "VimEnter",
	keys = {
		{
			"<tab>",
			function()
				local current_level = vim.fn.foldlevel("")

				if current_level > 3 then
					vim.api.nvim_input("za")
				else
					vim.api.nvim_input("<tab>")
				end
			end,
			desc = "Toggle fold",
		},
	},
	config = function()
		require("pretty-fold").setup({})
	end,
}

return {
	'm-housh/swift.nvim',
	dependencies = {
		'akinsho/toggleterm.nvim'
	},
	event = "VeryLazy",
	config = function()
		require('swift').setup()
	end
}

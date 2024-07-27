return {
	"rshkarin/mason-nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mason-nvim-lint").setup()
	end
}

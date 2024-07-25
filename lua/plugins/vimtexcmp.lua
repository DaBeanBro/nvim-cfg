return {
	"micangl/cmp-vimtex",
	config = function()
		local cmp_tex = require('cmp_vimtex')
		cmp_tex.setup({
			additional_information = {
				info_in_menu = true,
				info_in_window = true,
				info_max_length = 60,
				match_against_info = true,
				symbols_in_menu = true,
			},
			bibtex_parser = {
				enabled = true,
			},
			search = {
				browser = "xdg-open",
				default = "google_scholar",
				search_engines = {
					google_scholar = {
						name = "Google Scholar",
						get_url = require('cmp_vimtex').url_default_format(
						"https://scholar.google.com/scholar?hl=en&q=%s"),
					},
					-- Other search engines.
				},
			},
		})
		vim.keymap.set("n", "<leader>l<space>", function() require('cmp_vimtex.search').search_menu() end)
	end
}

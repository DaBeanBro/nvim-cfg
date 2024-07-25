local M = {
	"goolord/alpha-nvim",
	event = "VimEnter",
}

function M.config()
	local dashboard = require "alpha.themes.dashboard"

	local function button(sc, txt, keybind, keybind_opts)
		local b = dashboard.button(sc, txt, keybind, keybind_opts)
		b.opts.hl_shortcut = "Boolean"
		return b
	end

	dashboard.section.header.val = {
		[[                               __                ]],
		[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
		[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
		[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
		[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
		[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
	}

	dashboard.section.header.val = {
		[[🛸         🌎  °    🌓  •    .°•      🚀 ✯   ]],
		[[      ★  *          °        🛰   °·      🪐 ]],
		[[.      •  ° ★  •  ☄                          ]],
		[[                 ▁▂▃▄▅▆▇▇▆▅▄▃▂▁.             ]],
	}

	dashboard.section.buttons.val = {
		button("f", "  Find file", ":Telescope find_files <CR>"),
		button("n", "  New file", ":ene <BAR> startinsert <CR>"),
		-- button("s", icons.ui.SignIn .. " Load session", ":lua require('persistence').load()<CR>"),
		button("p", "  Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
		button("r", "  Recent files", ":Telescope oldfiles <CR>"),
		button("t", "  Find text", ":Telescope live_grep <CR>"),
		button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
		button("q", "  Quit", ":qa<CR>"),
	}
	local function footer()
		return "chrisatmachine.com"
	end

	dashboard.section.footer.val = footer()

	dashboard.section.header.opts.hl = "Function"
	dashboard.section.buttons.opts.hl = "Boolean"
	dashboard.section.footer.opts.hl = "@keyword.return"

	dashboard.opts.opts.noautocmd = true
	require("alpha").setup(dashboard.opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			dashboard.section.footer.val = "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
			pcall(vim.cmd.AlphaRedraw)
		end,
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = { "AlphaReady" },
		callback = function()
			vim.cmd [[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
		end,
	})
end

return M

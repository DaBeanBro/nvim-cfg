return {
  "folke/zen-mode.nvim",
  opts = {
    on_open = function(win)
      vim.wo[win].fillchars = vim.go.fillchars
      vim.wo[win].winbar = "%{%v:lua.dropbar.get_dropbar_str()%}"
    end,
  },
  cmd = "ZenMode",
}

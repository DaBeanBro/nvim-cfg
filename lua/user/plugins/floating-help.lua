return {
  "Tyler-Barham/floating-help.nvim",
  config = function()
    local fh = require("floating-help")
    fh.setup({})

    vim.keymap.set("n", "<C-h>", function()
      if not pcall(fh.toggle) then
        fh.toggle("options")
      end
    end, { desc = "help: toggle float" })
  end,
  cmd = "FloatingHelp",
}

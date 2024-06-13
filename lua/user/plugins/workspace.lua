return {
  "sanathks/workspace.nvim",
  dependencies = {"nvim-telescope/telescope.nvim"},
  config = function()
    require("workspace").setup({
      workspaces = {
        { name = "Work",  path = "~/projects/",  keymap = { "<leader>ws" } },
      }
    })
  end,
}

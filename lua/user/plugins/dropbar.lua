return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {},
  },
}

return {
  "arsham/fzfmania.nvim",
  dependencies = {
    "arsham/arshlib.nvim",
    "junegunn/fzf.vim",
    "nvim-lua/plenary.nvim",
    "nvim-lua/plenary.nvim",
    -- uncomment if you want a better ui.
    {
      "ibhagwan/fzf-lua",
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },
  },
  opts = {
    frontend = "fzf-lua", -- uncomment if you want a better ui.
  },
  event = { "VeryLazy" },
}

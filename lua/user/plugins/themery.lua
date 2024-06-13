return {
  "zaldih/themery.nvim",
  dependencies = {
    'nvim-telescope/telescope.nvim',
    -- Temas --
    {
      "catppuccin/nvim", name = "catppuccin"
    },
    {
      "Everblush/nvim", name = "everblush"
    },
    "ellisonleao/gruvbox.nvim",
    "neanias/everforest-nvim",
    "navarasu/onedark.nvim",
    "EdenEast/nightfox.nvim",
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
    "shaunsingh/nord.nvim",
    "craftzdog/solarized-osaka.nvim",
    "AlexvZyl/nordic.nvim",
    "Mofiqul/dracula.nvim",
    "rmehri01/onenord.nvim",
    "tiagovla/tokyodark.nvim",
    "loctvl842/monokai-pro.nvim",
    "xero/miasma.nvim",
    "LunarVim/horizon.nvim",
  },
  config = function()
    require("themery").setup({
      themes = {
        {
          name = "Gruvbox Dark",
          colorscheme = "gruvbox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Osaka",
          colorscheme = "solarized-osaka",
          before = [[ vim.opt.background = "dark" ]],
        },
        {
          name = "Horizon",
          colorscheme = "horizon",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Miasma",
          colorscheme = "miasma",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Everforest Dark",
          colorscheme = "everforest",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Everblush",
          colorscheme = "everblush",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Onedark",
          colorscheme = "onedark",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Nord",
          colorscheme = "nord",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Nordic",
          colorscheme = "nordic",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Onenord",
          colorscheme = "onenord",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Dracula",
          colorscheme = "dracula",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Tokyonight",
          colorscheme = "tokyonight",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Tokyodark",
          colorscheme = "tokyodark",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro",
          colorscheme = "monokai-pro-default",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro Octagon",
          colorscheme = "monokai-pro-octagon",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro Machine",
          colorscheme = "monokai-pro-machine",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro Ristretto",
          colorscheme = "monokai-pro-ristretto",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro Spectrum",
          colorscheme = "monokai-pro-spectrum",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Monokai Pro Classic",
          colorscheme = "monokai-pro-classic",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Kanagawa Wave",
          colorscheme = "kanagawa-wave",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Kanagawa Dragon",
          colorscheme = "kanagawa-dragon",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Catppuccin Mocha",
          colorscheme = "catppuccin-mocha",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Catppuccin Macchiato",
          colorscheme = "catppuccin-macchiato",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Catppuccin Frappe",
          colorscheme = "catppuccin-frappe",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Duskfox",
          colorscheme = "duskfox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Nightfox",
          colorscheme = "nightfox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Nordfox",
          colorscheme = "nordfox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Terafox",
          colorscheme = "terafox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Carbonfox",
          colorscheme = "carbonfox",
          before = [[ vim.opt.background = "dark" ]],
        },

        {
          name = "Gruvbox Light",
          colorscheme = "gruvbox",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Everforest Light",
          colorscheme = "everforest",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Onenord Light",
          colorscheme = "onenord-light",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Kanagawa Lotus",
          colorscheme = "kanagawa-lotus",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Catppuccin Latte",
          colorscheme = "catppuccin-latte",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Dawnfox",
          colorscheme = "dawnfox",
          before = [[ vim.opt.background = "light" ]],
        },

        {
          name = "Dayfox",
          colorscheme = "dayfox",
          before = [[ vim.opt.background = "light" ]],
        },


      },

      themeConfigFile = "~/.config/nvim/init.lua",
      livePreview = true,
    })

    vim.g.theme_id = 1
    vim.keymap.set('n', '<leader>fc', ':Themery<CR>', { desc = "Choose theme" })
  end
}

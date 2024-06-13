return {
  "folke/which-key.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = function()
    local icons = require("utils.icons")
    local whichkey = require('which-key')


    whichkey.register({
      ["<leader>"] = {                                    -- This maps to the leader key (commonly set to "\")
        f = {
          name = icons.get("ui").Search .. " Fuzzy Find", -- Adds a description to the "f" key for fuzzy finding
        },
        s = {
          name = icons.get("misc").Ghost .. " Session", -- Adds a description to the "s" key for session management
          l = {
            name = "List Sessions"                      -- Maps <leader>s + l to "List Sessions"
          },
          n = {
            name = "New Session" -- Maps <leader>s + n to "New Session"
          },
          u = {
            name = "Update Session" -- Maps <leader>s + u to "Update Session"
          },
          d = {
            name = "Delete Session" -- Maps <leader>s + d to "Delete Session"
          },
        },
      },
    })

    whichkey.setup {
      plugins = {
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = true,
        },
      },

      icons = {
      },

      window = {
        border = "none",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 1, 1, 1 },
        winblend = 0,
      },
    }
  end
}

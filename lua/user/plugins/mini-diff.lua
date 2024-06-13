return {
  'echasnovski/mini.diff',
  version = false,
  event = 'VeryLazy',
  keys = {
    { '<leader>md', ':lua require("mini.diff").toggle_overlay()<cr>', desc = 'Mini.Diff: toggle overlay' },
  },
  config = function()
    local diff = require 'mini.diff'
    diff.setup { source = diff.gen_source.save() }
  end,
}

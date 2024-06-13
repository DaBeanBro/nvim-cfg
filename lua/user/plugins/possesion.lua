return {
  'jedrzejboczar/possession.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },

  config = function()
    require('possession').setup {
      session_dir = (vim.fn.stdpath('data') .. 'possession'),
      silent = false,
      load_silent = true,
      debug = false,
      logfile = false,
      prompt_no_cr = false,
      autosave = {
        current = false,   -- or fun(name): boolean
        cwd = false,       -- or fun(): boolean
        tmp = false,       -- or fun(): boolean
        tmp_name = 'tmp', -- or fun(): string
        on_load = false,
        on_quit = false,
      },
      autoload = {
        cwd = false, -- or fun(): boolean
      },
      commands = {
        save = 'PossessionSave',
        load = 'PossessionLoad',
        save_cwd = 'PossessionSaveCwd',
        load_cwd = 'PossessionLoadCwd',
        rename = 'PossessionRename',
        close = 'PossessionClose',
        delete = 'PossessionDelete',
        show = 'PossessionShow',
        list = 'PossessionList',
        migrate = 'PossessionMigrate',
      },
      hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data) return user_data end,
        after_load = function(name, user_data) end,
      },
      plugins = {
        close_windows = {
          hooks = { 'before_save', 'before_load' },
          preserve_layout = true, -- or fun(win): boolean
          match = {
            floating = true,
            buftype = {},
            filetype = {},
            custom = false, -- or fun(win): boolean
          },
        },
        delete_hidden_buffers = {
          hooks = {
            'before_load',
            vim.o.sessionoptions:match('buffer') and 'before_save',
          },
          force = false, -- or fun(buf): boolean
        },
        nvim_tree = true,
        neo_tree = true,
        symbols_outline = true,
        outline = true,
        tabby = true,
        dap = true,
        dapui = true,
        neotest = true,
        delete_buffers = false,
      },
      telescope = {
        previewer = {
          enabled = true,
          previewer = 'pretty', -- or 'raw' or fun(opts): Previewer
          wrap_lines = true,
          include_empty_plugin_data = false,
          cwd_colors = {
            cwd = 'Comment',
            tab_cwd = { '#cc241d', '#b16286', '#d79921', '#689d6a', '#d65d0e', '#458588' }
          }
        },
        list = {
          default_action = 'load',
          mappings = {
            save = { n = '<c-x>', i = '<c-x>' },
            load = { n = '<c-v>', i = '<c-v>' },
            delete = { n = '<c-t>', i = '<c-t>' },
            rename = { n = '<c-r>', i = '<c-r>' },
          },
        },
      },
    }

    vim.keymap.set('n', '<leader>ss', ':PossessionSave<cr>')
    vim.keymap.set('n', '<leader>sr', ':PossessionRename<cr>')
    vim.keymap.set('n', '<leader>sd', ':PossessionDelete<cr>')
  end
}

local fl = setmetatable({}, {
  __index = function(_, k)
    return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k)
  end,
})

return {
  {

    'phanen/fzf-lua-overlay',
    cond = not vim.g.vscode,
    init = function() require('fzf-lua-overlay').init() end,
    -- stylua: ignore
    keys = {
      -- try new pickers
      -- { '+<c-f>',        fl.lazy,             mode = { 'n', 'x' } },
      -- { '+e',            fl.grep_notes,       mode = { 'n' } },
      -- { "+fi",           fl.gitignore,        mode = { 'n', 'x' } },
      -- { "+fl",           fl.license,          mode = { 'n', 'x' } },
      -- { '+fr',           fl.rtp,              mode = { 'n', 'x' } },
      -- { '+fs',           fl.scriptnames,      mode = { 'n', 'x' } },
      -- { '<leader><c-f>', fl.zoxide,           mode = { 'n', 'x' } },
      -- { '<leader><c-j>', fl.todo_comment,     mode = { 'n', 'x' } },
      -- { '<leader>e',     fl.find_notes,       mode = { 'n', 'x' } },
      -- { '<leader>fo',    fl.recentfiles,      mode = { 'n', 'x' } },
      -- { '<leader>dot',   fl.find_dots,        mode = { 'n', 'x' } },
      -- { '+l',            fl.grep_dots,        mode = { 'n', 'x' } },

      -- all fzf-lua's builtin pickers work transparently with visual mode support
      -- { '<c-b>', fl.buffers,          mode = { 'n', 'x' } },
      -- { '<c-l>', fl.files,            mode = { 'n', 'x' } },
      -- { '<c-n>', fl.live_grep_native, mode = { 'n', 'x' } },
    },
    opts = {},
  },
  -- config fzf-lua still work well
  { 'ibhagwan/fzf-lua', cmd = { 'FzfLua' }, opts = {} },
}

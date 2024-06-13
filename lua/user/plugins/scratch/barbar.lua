return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('barbar').setup({
        no_name_title = '[No Name]',
        insert_at_end = true,
        exclude_name = { '[dap-repl]' },
        exclude_ft = { 'qf' },
        maximum_length = 60,
        hide = { extensions = true, },
        icons = { button = false, },
      })
    end
  }
}

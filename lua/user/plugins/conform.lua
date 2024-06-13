return {
  'stevearc/conform.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        go = { 'goimports', 'gofumpt' },
        fish = { 'fish_indent' },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    })
    conform.formatters.shfmt = {
      prepend_args = { '--indent', '2' },
    }
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}

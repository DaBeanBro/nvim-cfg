local map = vim.keymap.set
local builtin = require'telescope.builtin'

map('n', '<leader>f<leader>', builtin.find_files, { desc = "Find Files" })

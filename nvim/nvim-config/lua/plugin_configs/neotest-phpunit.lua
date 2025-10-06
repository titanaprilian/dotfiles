require('neotest').setup {
  adapters = {
    require 'neotest-phpunit',
  },
}

vim.api.nvim_set_keymap('n', '<C-t>', ':lua require("neotest").run.run()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t-n>', 'lua require("neotest").run.run(vim.fn.expand("%"))', { noremap = true, silent = true })

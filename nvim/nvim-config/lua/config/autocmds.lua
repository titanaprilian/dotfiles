local augroup = vim.api.nvim_create_augroup('lsp_blade_workaround', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup,
  pattern = '*.php',
  callback = function()
    vim.bo.filetype = 'php'
  end,
})

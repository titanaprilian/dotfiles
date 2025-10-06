local harpoon = require 'harpoon'
harpoon:setup {}

vim.keymap.set('n', '<C-h>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<C-p>', function()
  harpoon:list():prev()
end)
vim.keymap.set('n', '<C-n>', function()
  harpoon:list():next()
end)

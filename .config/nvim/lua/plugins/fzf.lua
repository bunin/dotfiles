vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end)
vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').live_grep() end)
vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end)
vim.keymap.set('n', '<leader>fk', function() require('fzf-lua').keymaps() end)

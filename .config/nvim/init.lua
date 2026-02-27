vim.g.mapleader = ' '

-- Options
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd.colorscheme('lunaperche')

-- Plugins
vim.pack.add({
	'git@github.com:nvim-lua/plenary.nvim.git',
	'git@github.com:neovim/nvim-lspconfig.git',
	'git@github.com:ibhagwan/fzf-lua.git',
	'git@github.com:folke/which-key.nvim.git',
	'git@github.com:nvim-treesitter/nvim-treesitter.git',
	'git@github.com:ray-x/go.nvim.git',
	'git@github.com:ray-x/guihua.lua.git',
	'git@github.com:lewis6991/gitsigns.nvim.git',
	'git@github.com:rachartier/tiny-code-action.nvim.git',
	'git@github.com:sindrets/diffview.nvim.git',
	'git@github.com:NeogitOrg/neogit.git',
})

-- Plugin configs
require('plugins.lsp')
require('plugins.treesitter')
require('plugins.gitsigns')
require('plugins.fzf')
require('plugins.go')
require('which-key').setup()

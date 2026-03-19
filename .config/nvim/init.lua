vim.g.mapleader = ' '

-- Options
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.cmd.colorscheme('lunaperche')

-- Plugins
vim.pack.add({
	'git@github.com:nvim-lua/plenary.nvim.git',
	'git@github.com:mason-org/mason.nvim.git',
	'git@github.com:mason-org/mason-lspconfig.nvim.git',
	'git@github.com:WhoIsSethDaniel/mason-tool-installer.nvim.git',
	'git@github.com:neovim/nvim-lspconfig.git',
	'git@github.com:ibhagwan/fzf-lua.git',
	'git@github.com:folke/which-key.nvim.git',
	'git@github.com:nvim-treesitter/nvim-treesitter.git',
	'git@github.com:ray-x/go.nvim.git',
	'git@github.com:ray-x/guihua.lua.git',
	'git@github.com:tanvirtin/vgit.nvim.git',
	'git@github.com:nvim-tree/nvim-web-devicons.git',
	'git@github.com:rachartier/tiny-code-action.nvim.git',
})

-- Plugin configs
require('plugins.lsp')
require('plugins.treesitter')
require('plugins.vgit')
require('plugins.fzf')
require('plugins.go')
require('which-key').setup()
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
	ensure_installed = {
		'lua_ls',
		'stylua',
	}
}

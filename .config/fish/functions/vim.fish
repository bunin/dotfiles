# Typing `vim` should get Neovim. Escape hatch: `command vim` for /usr/bin/vim.
function vim --wraps nvim --description 'Neovim'
    nvim $argv
end

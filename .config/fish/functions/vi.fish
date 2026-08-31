# Typing `vi` should get Neovim too. Escape hatch: `command vi` for /usr/bin/vi.
function vi --wraps nvim --description 'Neovim'
    nvim $argv
end

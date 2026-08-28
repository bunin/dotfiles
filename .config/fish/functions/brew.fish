function brew --wraps='sudo -E -H -u homebrew brew' --description 'alias brew sudo -E -H -u homebrew brew'
  sudo -E -H -u homebrew brew $argv
end

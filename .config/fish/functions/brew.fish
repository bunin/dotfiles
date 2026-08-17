function brew --wraps='sudo -E -u homebrew' --description 'alias brew sudo -E -H -u homebrew brew'
  sudo -E -H -u homebrew brew $argv
end

function brew --wraps=brew --description 'Run brew as the dedicated homebrew user'
  # Pass the resolved path: on Linux sudo's secure_path does not include
  # the linuxbrew bin dir, and the sudoers rule matches the full path.
  sudo -E -H -u homebrew (command -s brew) $argv
end

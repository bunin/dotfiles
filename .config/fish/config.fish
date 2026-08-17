# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/s9s/.docker/bin"
# End of Docker Desktop section.

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g theme_display_k8s_context yes
    set -g theme_display_k8s_namespace yes
end

# pnpm
set -gx PNPM_HOME "/Users/s9s/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if status is-interactive
    atuin init fish | source
end

# brew runs as user `homebrew`, which cannot traverse ~/Library (mode 700)
set -gx HOMEBREW_CASK_OPTS "--fontdir=/Library/Fonts"

# Neovim everywhere: git, kubectl edit, crontab, fzf, etc.
# `vim` is a function (functions/vim.fish); `command vim` still reaches /usr/bin/vim
set -gx EDITOR nvim
set -gx VISUAL nvim

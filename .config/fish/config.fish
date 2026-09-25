# fish_add_path dedupes against fish_user_paths, not $PATH, so paths already set
# by universals would be added twice.
for dir in $HOME/.docker/bin $HOME/go/bin $HOME/.lmstudio/bin
    test -d $dir; and not contains -- $dir $PATH; and set -gx PATH $PATH $dir
end

for dir in $HOME/.local/bin $HOME/.local/share/mise/shims $HOME/.opencode/bin
    test -d $dir; and not contains -- $dir $PATH; and set -gx PATH $dir $PATH
end

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
test -d $PNPM_HOME; and not contains -- $PNPM_HOME $PATH; and set -gx PATH $PNPM_HOME $PATH

# mise lives in ~/.local/bin, prepended just above. The shims directory goes on
# PATH alongside it so the tools survive the handoff to a child process: this
# activation is fish-only, but PATH is exported, so a `bash -c` started from here
# still resolves kubectl and friends. Activation runs after the loop, putting the
# real tool paths ahead of the shims, so fish itself never pays the shim hop.
command -q mise; and mise activate fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
    # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
    command -q aws_completer; and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

if status is-interactive
    atuin init fish | source
    # Omarchy's conf.d/omarchy.fish already did this; running it twice is harmless.
    command -q starship; and starship init fish | source
end

# Non-interactive bash reads no startup file on its own, so `k`/`kc`/`kn` would
# be missing from `bash -c` and from anything that shells out that way. BASH_ENV
# names a file for it to read; ~/.bashrc sources the same one for interactive
# shells. It costs every bash script started from this session one extra source,
# which is why that file stays silent and side-effect free.
test -f $HOME/.config/bash/env.bash; and set -gx BASH_ENV $HOME/.config/bash/env.bash

# Neovim everywhere: git, kubectl edit, crontab, fzf, etc.
# `vim`/`vi` are functions (functions/vim.fish, functions/vi.fish);
# `command vim` still reaches /usr/bin/vim.
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

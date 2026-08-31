# fish_add_path dedupes against fish_user_paths, not $PATH, so paths already set
# by universals would be added twice.
for dir in $HOME/.docker/bin $HOME/go/bin $HOME/.lmstudio/bin
    test -d $dir; and not contains -- $dir $PATH; and set -gx PATH $PATH $dir
end

for dir in $HOME/.local/bin $HOME/.opencode/bin
    test -d $dir; and not contains -- $dir $PATH; and set -gx PATH $dir $PATH
end

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
test -d $PNPM_HOME; and not contains -- $PNPM_HOME $PATH; and set -gx PATH $PNPM_HOME $PATH

# mise lives in ~/.local/bin, prepended just above.
command -q mise; and mise activate fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g theme_display_k8s_context yes
    set -g theme_display_k8s_namespace yes

    # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
    command -q aws_completer; and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

if status is-interactive
    atuin init fish | source
end

# Neovim everywhere: git, kubectl edit, crontab, fzf, etc.
# `vim`/`vi` are functions (functions/vim.fish, functions/vi.fish);
# `command vim` still reaches /usr/bin/vim.
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

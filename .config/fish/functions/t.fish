# `--wraps` hands `t` tmux's own completions, so `t attach<TAB>` behaves.
function t --wraps tmux --description 'tmux'
    tmux $argv
end

# `--wraps` hands `h` herdr's own completions, so `h attach<TAB>` behaves.
function h --wraps herdr --description 'herdr'
    herdr $argv
end

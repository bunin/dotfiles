# `--wraps` hands `k` kubectl's own completions, so `k get po<TAB>` behaves.
function k --wraps kubectl --description 'kubectl'
    kubectl $argv
end

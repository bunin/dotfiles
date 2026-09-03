# The bash half of functions/{k,kc,kn}.fish. Functions rather than aliases:
# non-interactive bash ignores aliases outright, and BASH_ENV exists to reach
# exactly those shells. Completions for `k` are generated, not defined here —
# see the README.
k() { kubectl "$@"; }
kc() { kubectx "$@"; }
kn() { kubens "$@"; }

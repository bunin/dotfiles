# What every bash in this session gets, interactive or not: ~/.bashrc sources
# this file, and BASH_ENV (set in config.fish) points non-interactive shells at
# it. That second path runs before every bash script the session starts, so
# everything sourced here must stay silent, fast, and free of side effects —
# no output, no `set -e`, and no PATH edit that is not guarded against repeating
# itself, since a nested bash re-runs this file over a PATH it already touched.
[[ -r ~/.config/bash/kubernetes.bash ]] && source ~/.config/bash/kubernetes.bash

# mise is activated in config.fish, so a bash that did not descend from fish —
# an ssh session, a rescue console — sees none of the tools it manages, kubectl
# among them. The shims directory is the part of mise that is just a PATH entry:
# no hook, no subshell, nothing to run at startup.
if [[ -d $HOME/.local/share/mise/shims ]] &&
   [[ :$PATH: != *:$HOME/.local/share/mise/shims:* ]]; then
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# `source` leaves the last test's status behind; a non-zero one here would make
# bash -c report failure before the script runs a single line.
true

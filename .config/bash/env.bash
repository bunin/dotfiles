# What every bash in this session gets, interactive or not: ~/.bashrc sources
# this file, and BASH_ENV (set in config.fish) points non-interactive shells at
# it. That second path runs before every bash script the session starts, so
# everything sourced here must stay silent, fast, and free of side effects —
# no output, no PATH edits, no `set -e`. Function and variable definitions only.
[[ -r ~/.config/bash/kubernetes.bash ]] && source ~/.config/bash/kubernetes.bash

# `source` leaves the last test's status behind; a non-zero one here would make
# bash -c report failure before the script runs a single line.
true

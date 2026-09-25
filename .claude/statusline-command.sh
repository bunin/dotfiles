#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
# The context size in the name repeats what the context block shows.
model=$(echo "$input" | jq -r '.model.display_name // empty' | sed 's/^Claude //; s/ *([^)]*context)$//')
# Shortened like fish's prompt_pwd: ~ for $HOME, every directory but the last
# cut to its first character (two for dot-directories).
short_cwd=$(printf '%s' "$cwd" | awk -v home="$HOME" '{
  if ($0 == home) { print "~"; exit }
  if (index($0, home "/") == 1) $0 = "~" substr($0, length(home) + 1)
  n = split($0, p, "/")
  for (i = 1; i < n; i++) if (p[i] != "") p[i] = substr(p[i], 1, substr(p[i], 1, 1) == "." ? 2 : 1)
  out = p[1]
  for (i = 2; i <= n; i++) out = out "/" p[i]
  print out
}')
printf '\033[01;34m%s\033[00m' "$short_cwd"

# --no-optional-locks keeps this from racing a git command running in the repo.
git_info=$(git --no-optional-locks -C "$cwd" status --porcelain=v2 --branch 2>/dev/null | awk '
  /^# branch.oid/  { oid = substr($3, 1, 7) }
  /^# branch.head/ { head = $3 }
  /^# branch.ab/   { ahead = substr($3, 2) + 0; behind = substr($4, 2) + 0 }
  /^[12] / { if (substr($2, 1, 1) != ".") staged++; if (substr($2, 2, 1) != ".") modified++ }
  /^u /    { conflicted++ }
  /^\? /   { untracked++ }
  END {
    if (head == "") exit
    # The same symbols as the jetpack preset in starship.toml.
    if (ahead && behind) st = "◇ ▴┤" ahead "│▿┤" behind "│"
    else if (ahead) st = "▴│" ahead "│"
    else if (behind) st = "▿│" behind "│"
    if (staged) st = st "▪┤" staged "│"
    if (modified) st = st "●◦"
    if (untracked) st = st "◌◦"
    if (conflicted) st = st "◪◦"
    out = (head == "(detached)") ? oid : head
    if (st != "") out = out " ⎪" st "⎥"
    print out
  }')
[ -n "$git_info" ] && printf ' \033[00;32m%s\033[00m' "$git_info"

if command -v kubectl >/dev/null 2>&1; then
  kube=$(kubectl config view --minify -o 'jsonpath={.current-context}{"\t"}{..namespace}' 2>/dev/null)
  kube_ctx=${kube%%"	"*}
  kube_ns=${kube#*"	"}
  if [ -n "$kube_ctx" ]; then
    printf ' \033[00;94m⎈ %s' "$kube_ctx"
    [ -n "$kube_ns" ] && printf ' (%s)' "$kube_ns"
    printf '\033[00m'
  fi
fi

[ -n "$model" ] && printf ' \033[00;35m[%s]\033[00m' "$model"

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
if [ -n "$ctx_pct" ] && [ -n "$ctx_size" ]; then
  ctx_used=$(echo "$ctx_pct $ctx_size" | awk '{printf "%d", $1 * $2 / 100}')
  fmt_num() {
    n=$1
    if [ "$n" -ge 1000000 ]; then
      printf '%.4g' "$(echo "$n" | awk '{printf "%.10f", $1/1000000}')" | sed 's/\.0*$//;s/\(\.[0-9]*[1-9]\)0*/\1/'
      printf 'm'
    elif [ "$n" -ge 1000 ]; then
      printf '%.4g' "$(echo "$n" | awk '{printf "%.10f", $1/1000}')" | sed 's/\.0*$//;s/\(\.[0-9]*[1-9]\)0*/\1/'
      printf 'k'
    else
      printf '%d' "$n"
    fi
  }
  used_fmt=$(fmt_num "$ctx_used")
  size_fmt=$(fmt_num "$ctx_size")
  printf ' \033[00;36m%s/%s (%s%%)\033[00m' "$used_fmt" "$size_fmt" "$ctx_pct"
fi

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ]; then
  filled=$(echo "$five_pct" | awk '{printf "%.0f", $1 / 10}')
  empty=$((10 - filled))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
  i=0
  while [ $i -lt $empty ]; do bar="${bar}░"; i=$((i+1)); done
  time_left=""
  if [ -n "$five_resets" ]; then
    now=$(date +%s)
    secs_left=$((five_resets - now))
    if [ "$secs_left" -gt 0 ]; then
      mins_left=$(( (secs_left + 59) / 60 ))
      h=$((mins_left / 60))
      m=$((mins_left % 60))
      if [ "$h" -gt 0 ]; then
        time_left=" ${h}h${m}m"
      else
        time_left=" ${m}m"
      fi
    else
      time_left=" resetting"
    fi
  fi
  gmt_hour=$(date -u +%H | sed 's/^0//')
  ESC=$(printf '\033')
  if [ "$gmt_hour" -ge 13 ] && [ "$gmt_hour" -lt 19 ]; then
    peak_mark=" ${ESC}[01;31mpeak${ESC}[01;33m"
  else
    peak_mark=" ${ESC}[00;32moff-peak${ESC}[01;33m"
  fi
  printf ' \033[01;33m5h:[%s] %.0f%%%s%s\033[00m' "$bar" "$five_pct" "$time_left" "$peak_mark"
fi

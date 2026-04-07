#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$(whoami)" "$(hostname -s)" "$cwd"

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

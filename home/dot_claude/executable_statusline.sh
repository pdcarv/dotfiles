#!/bin/bash
# Claude Code status line: model, directory, context usage and the claude.ai
# 5-hour / 7-day usage limits. Limits are coloured by pace: how much of the
# window would be used by its reset at the current rate. Cost is shown only
# when there are no limits (API-key sessions), where it is real spend.
# Reads the session JSON on stdin.

input=$(cat)

IFS=$'\x1f' read -r model dir used pct cost five_pct five_reset week_pct week_reset < <(
  jq -r '[
    .model.display_name // "?",
    (.workspace.current_dir // .cwd // "" | split("/") | last // ""),
    .context_window.total_input_tokens // 0,
    (.context_window.used_percentage // 0 | floor),
    .cost.total_cost_usd // 0,
    (.rate_limits.five_hour.used_percentage // "" | if . == "" then . else floor end),
    (.rate_limits.five_hour.resets_at // "" | if . == "" then . else floor end),
    (.rate_limits.seven_day.used_percentage // "" | if . == "" then . else floor end),
    (.rate_limits.seven_day.resets_at // "" | if . == "" then . else floor end)
  ] | map(tostring) | join("\u001f")' <<<"$input"
)

dim=$'\e[2m' reset=$'\e[0m'
sep=" ${dim}·${reset} "
now=$(date +%s)

# Green under 50%, yellow under 80%, red above.
color() {
  if (($1 >= 80)); then printf '\e[31m'
  elif (($1 >= 50)); then printf '\e[33m'
  else printf '\e[32m'
  fi
}

# 1234 -> 1k, 1234567 -> 1.2M
human() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1e6) printf "%.1fM", n / 1e6
    else if (n >= 1e3) printf "%.0fk", n / 1e3
    else printf "%d", n
  }'
}

bar() {
  local width=8 filled=$(($1 * 8 / 100)) out=""
  ((filled > width)) && filled=$width
  for ((i = 0; i < width; i++)); do
    if ((i < filled)); then out+="█"; else out+="░"; fi
  done
  printf '%s' "$out"
}

# Seconds as 2h13m, 3d4h or 45m.
duration() {
  local s=$1
  if ((s >= 86400)); then printf '%dd%dh' $((s / 86400)) $((s % 86400 / 3600))
  elif ((s >= 3600)); then printf '%dh%02dm' $((s / 3600)) $((s % 3600 / 60))
  else printf '%dm' $((s / 60))
  fi
}

# limit LABEL USED% RESETS_AT WINDOW_SECONDS
# The colour comes from the projected use at reset (used / elapsed share of the
# window), so 40% used one hour into a 5h window shows red. Early in a window
# the projection is noisy, so the plain percentage is used until 10% has passed.
limit() {
  local label=$1 p=$2 at=$3 window=$4 left elapsed projected
  [[ -z $p ]] && return
  printf '%s' "$sep"
  if [[ -n $at ]] && ((at > now)); then
    left=$((at - now))
    elapsed=$((window - left))
    if ((elapsed * 10 >= window)); then
      projected=$((p * window / elapsed))
    else
      projected=$p
    fi
    printf '%s%s %s %s%%%s %s↻%s%s' "$(color "$projected")" "$label" "$(bar "$p")" "$p" "$reset" \
      "$dim" "$(duration "$left")" "$reset"
  else
    printf '%s%s %s %s%%%s' "$(color "$p")" "$label" "$(bar "$p")" "$p" "$reset"
  fi
}

printf '\e[1m%s\e[0m' "$model"
[[ -n $dir ]] && printf '%s%s' "$sep" "$dir"
printf '%s%sctx %s%%%s %s%s%s' "$sep" "$(color "$pct")" "$pct" "$reset" "$dim" "$(human "$used")" "$reset"
if [[ -n $five_pct || -n $week_pct ]]; then
  limit 5h "$five_pct" "$five_reset" $((5 * 3600))
  limit 7d "$week_pct" "$week_reset" $((7 * 86400))
else
  printf '%s$%.2f' "$sep" "$cost"
fi
printf '\n'

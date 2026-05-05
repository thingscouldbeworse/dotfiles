#!/usr/bin/env bash
# Per-core CPU mini-graph for Waybar (JSON). Uses /proc/stat deltas.
set -euo pipefail

PREV="${XDG_RUNTIME_DIR:-/tmp}/waybar_cpu_prev"
CHARS='▁▂▃▄▅▆▇█'

read_cores() {
  awk '/^cpu[0-9]+/ {
    n = $1; sub(/^cpu/, "", n)
    idle = $5 + $6
    total = 0
    for (i = 2; i <= NF; i++) total += $i
    nonidle = total - idle
    print n " " nonidle " " total
  }' /proc/stat | sort -n -k1,1
}

bar_char() {
  local p="$1"
  if (( p < 0 )); then p=0; elif (( p > 100 )); then p=100; fi
  local idx=$(( (p * (${#CHARS} - 1) + 50) / 100 ))
  printf '%s' "${CHARS:$idx:1}"
}

mapfile -t NOW < <(read_cores)
n="${#NOW[@]}"
if (( n == 0 )); then
  printf '%s\n' '{"text":"cpu?","percentage":0}'
  exit 0
fi

if [[ ! -f "$PREV" ]] || [[ $(wc -l <"$PREV") -ne $n ]]; then
  printf '%s\n' "${NOW[@]}" >"$PREV"
  printf '%s\n' '{"text":"…","percentage":0,"tooltip":"collecting CPU sample…"}'
  exit 0
fi

mapfile -t WAS < <(cat -- "$PREV")
printf '%s\n' "${NOW[@]}" >"$PREV"

text=""
tooltip=""
sum=0
for (( i = 0; i < n; i++ )); do
  read -r _ ni1 t1 <<<"${WAS[$i]}"
  read -r _ ni2 t2 <<<"${NOW[$i]}"
  dni=$((ni2 - ni1))
  dt=$((t2 - t1))
  if (( dt <= 0 )); then pct=0; else pct=$(( dni * 100 / dt )); fi
  if (( pct < 0 )); then pct=0; elif (( pct > 100 )); then pct=100; fi
  sum=$((sum + pct))
  text+="$(bar_char "$pct")"
  tooltip+="cpu${i}: ${pct}%"$'\n'
done

avg=$((sum / n))
tooltip="${tooltip%$'\n'}"

# Bar graph + average CPU % (matches xmobar-style “total” at a glance)
text="${text} ${avg}%"

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' <<<"$1"
}

t_json="$(json_escape "$tooltip")"
printf '{"text":"%s","percentage":%s,"tooltip":%s}\n' "$text" "$avg" "$t_json"

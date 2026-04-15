#!/usr/bin/env bash
# RAM usage: one bar + percent. Tooltip shows MemTotal / MemAvailable / breakdown.
# RAM is not "per-core"; /proc/meminfo gives whole-machine lines only.
set -euo pipefail

CHARS='▁▂▃▄▅▆▇█'

bar_char() {
  local p="$1"
  if (( p < 0 )); then p=0; elif (( p > 100 )); then p=100; fi
  local idx=$(( (p * (${#CHARS} - 1) + 50) / 100 ))
  printf '%s' "${CHARS:$idx:1}"
}

# kB numbers from /proc/meminfo
eval "$(awk '/^MemTotal:|^MemAvailable:|^Buffers:|^Cached:|^SReclaimable:/ {
  gsub(/ +kB$/,"",$2)
  if ($1 ~ /^MemTotal:/) print "mt=" $2
  if ($1 ~ /^MemAvailable:/) print "ma=" $2
  if ($1 ~ /^Buffers:/) print "buf=" $2
  if ($1 ~ /^Cached:/) print "cac=" $2
  if ($1 ~ /^SReclaimable:/) print "srec=" $2
}' /proc/meminfo)"

: "${mt:=0}" "${ma:=0}" "${buf:=0}" "${cac:=0}" "${srec:=0}"

if (( mt <= 0 )); then
  printf '%s\n' '{"text":"mem?","percentage":0}'
  exit 0
fi

# "Used" vs total: complement of MemAvailable (Linux's own notion of "free enough")
used=$((mt - ma))
pct=$(( used * 100 / mt ))
if (( pct < 0 )); then pct=0; elif (( pct > 100 )); then pct=100; fi

b="$(bar_char "$pct")"
text="ram ${b} ${pct}%"

tooltip=$(
  printf 'MemTotal:     %s MiB\n' "$((mt / 1024))"
  printf 'MemAvailable: %s MiB\n' "$((ma / 1024))"
  printf 'Used≈:        %s MiB (%s%%)\n' "$((used / 1024))" "$pct"
  printf 'Buffers:      %s MiB\n' "$((buf / 1024))"
  printf 'Cache+SRec:   ~%s MiB\n' "$(((cac + srec) / 1024))"
  printf '\n(No per-CPU RAM; use per-cgroup tools if you need that.)'
)

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' <<<"$1"
}

t_json="$(json_escape "$tooltip")"
printf '{"text":"%s","percentage":%s,"tooltip":%s}\n' "$text" "$pct" "$t_json"

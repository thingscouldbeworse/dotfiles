#!/usr/bin/env bash
# GPU utilization bar + % for Waybar (JSON). NVIDIA: nvidia-smi; AMD: gpu_busy_percent sysfs.
set -eu
# Note: no pipefail — nvidia-smi can fail on AMD-only boxes; a failed pipeline would
# otherwise exit the whole script before we fall through to amdgpu sysfs.

CHARS='▁▂▃▄▅▆▇█'

bar_char() {
  local p="$1"
  if (( p < 0 )); then p=0; elif (( p > 100 )); then p=100; fi
  local idx=$(( (p * (${#CHARS} - 1) + 50) / 100 ))
  printf '%s' "${CHARS:$idx:1}"
}

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' <<<"$1"
}

pct=""
src=""

if command -v nvidia-smi &>/dev/null; then
  raw="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)" || raw=""
  raw="${raw//[[:space:]]/}"
  if [[ "$raw" =~ ^[0-9]+$ ]]; then
    pct="$raw"
    src="nvidia-smi (first GPU)"
  fi
fi

if [[ -z "$pct" ]]; then
  for f in /sys/class/drm/card[0-9]/device/gpu_busy_percent; do
    [[ -r "$f" ]] || continue
    raw="$(tr -d '[:space:]' <"$f" 2>/dev/null || true)"
    if [[ "$raw" =~ ^[0-9]+$ ]]; then
      pct="$raw"
      src="amdgpu $(basename "$(dirname "$(dirname "$f")")") gpu_busy_percent"
      break
    fi
  done
fi

if [[ -z "$pct" ]]; then
  tip=$'No GPU utilization source found.\n'
  tip+=$'- NVIDIA: install nvidia-utils (nvidia-smi).\n'
  tip+=$'- AMD: amdgpu + sysfs gpu_busy_percent (discrete card).\n'
  tip+=$'- Intel: not auto-detected here; extend script or use another tool.'
  t_json="$(json_escape "$tip")"
  printf '{"text":"gpu —","percentage":0,"tooltip":%s}\n' "$t_json"
  exit 0
fi

b="$(bar_char "$pct")"
text="gpu ${b} ${pct}%"
tip="${src}"$'\n'"Utilization ${pct}% (0–100)."
t_json="$(json_escape "$tip")"
printf '{"text":"%s","percentage":%s,"tooltip":%s}\n' "$text" "$pct" "$t_json"

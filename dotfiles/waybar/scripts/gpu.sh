#!/usr/bin/env bash
# ~/.config/waybar/scripts/gpu.sh
# Uso, temperatura e VRAM da GPU. Suporta NVIDIA (nvidia-smi) e AMD (sysfs).

ICON="󰢮"
usage=""; temp=""; name=""; vram=""

if command -v nvidia-smi &>/dev/null && nvidia-smi -L &>/dev/null; then
  IFS=',' read -r name usage temp vu vt < <(
    nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total \
               --format=csv,noheader,nounits | head -n1
  )
  name=${name# }; usage=${usage// /}; temp=${temp// /}; vu=${vu// /}; vt=${vt// /}
  vram="${vu} MiB / ${vt} MiB"
else
  for dev in /sys/class/drm/card*/device; do
    [[ -r "$dev/gpu_busy_percent" ]] || continue
    usage=$(<"$dev/gpu_busy_percent")
    t=$(cat "$dev"/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1)
    [[ -n "$t" ]] && temp=$((t / 1000))
    name="GPU AMD"
    if [[ -r "$dev/mem_info_vram_used" && -r "$dev/mem_info_vram_total" ]]; then
      vu=$(( $(<"$dev/mem_info_vram_used") / 1048576 ))
      vt=$(( $(<"$dev/mem_info_vram_total") / 1048576 ))
      vram="${vu} MiB / ${vt} MiB"
    fi
    break
  done
fi

if [[ -z "$usage" ]]; then
  printf '{"text":"%s  N/D","tooltip":"GPU não suportada pelo script (use nvidia-smi ou AMD)."}\n' "$ICON"
  exit 0
fi

class=""
(( usage >= 90 )) && class="critical"
(( usage < 90 && usage >= 70 )) && class="warning"

tooltip="$name\\nUso: ${usage}%"
[[ -n "$temp" ]] && tooltip+="\\nTemperatura: ${temp}°C"
[[ -n "$vram" ]] && tooltip+="\\nVRAM: ${vram}"

printf '{"text":"%s  %3s%%","tooltip":"%s","class":"%s","percentage":%s}\n' \
  "$ICON" "$usage" "$tooltip" "$class" "$usage"

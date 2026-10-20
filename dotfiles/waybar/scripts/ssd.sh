#!/usr/bin/env bash
# ~/.config/waybar/scripts/ssd.sh
# Nível de uso (atividade de I/O) do disco que contém a partição root.
# Funciona com NVMe/SATA, btrfs, LUKS e LVM.

ICON="󰋊"

src=$(findmnt -no SOURCE / | sed 's/\[.*//')
dev=$(lsblk -nslo NAME,TYPE "$src" 2>/dev/null | awk '$2=="disk"{print $1; exit}')

if [[ -z "$dev" ]]; then
  printf '{"text":"%s  N/D","tooltip":"Não foi possível identificar o disco."}\n' "$ICON"
  exit 0
fi

line=$(awk -v d="$dev" '$3==d' /proc/diskstats)
read -r _ _ _ _ _ rs _ _ _ ws _ _ io _ <<< "$line"

now=$(( $(date +%s%N) / 1000000 ))   # ms
state="/tmp/waybar-ssd-${UID}-${dev}"

util=0; rd="0.0"; wr="0.0"

if [[ -r "$state" ]]; then
  read -r pt pio prs pws < "$state"
  dt=$(( now - pt ))
  if (( dt > 0 )); then
    util=$(( (io - pio) * 100 / dt ))
    (( util > 100 )) && util=100
    (( util < 0 )) && util=0
    rd=$(awk -v s=$(( rs - prs )) -v t="$dt" 'BEGIN{printf "%.1f", s*512*1000/t/1048576}')
    wr=$(awk -v s=$(( ws - pws )) -v t="$dt" 'BEGIN{printf "%.1f", s*512*1000/t/1048576}')
  fi
fi

echo "$now $io $rs $ws" > "$state"

class=""
(( util >= 90 )) && class="critical"
(( util < 90 && util >= 70 )) && class="warning"

printf '{"text":"%s  %3s%%","tooltip":"Disco: /dev/%s\\nAtividade: %s%%\\nLeitura: %s MB/s\\nEscrita: %s MB/s","class":"%s","percentage":%s}\n' \
  "$ICON" "$util" "$dev" "$util" "$rd" "$wr" "$class" "$util"

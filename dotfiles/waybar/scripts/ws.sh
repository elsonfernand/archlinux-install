#!/usr/bin/env bash
# ~/.config/waybar/scripts/ws.sh N
# Mostra o workspace N somente se for o ativo ou se tiver janelas.
# Requer apenas hyprctl (sem jq).

n="$1"
cache="${XDG_RUNTIME_DIR:-/tmp}/waybar-ws.cache"

refresh() {
  local active occ tmp
  active=$(hyprctl activeworkspace -j 2>/dev/null |
    awk '/^[[:space:]]*"id":/ { gsub(/[^0-9-]/, "", $2); print $2; exit }')
  occ=$(hyprctl workspaces -j 2>/dev/null |
    awk '/^[[:space:]]*"id":/ { gsub(/[^0-9-]/, "", $2); id=$2 }
         /^[[:space:]]*"windows":/ { gsub(/[^0-9]/, "", $2); if ($2 + 0 > 0) printf "%s ", id }')
  [[ -z "$active" ]] && return 1   # não escreve cache se o hyprctl falhou
  tmp="$cache.$$"
  printf '%s\n%s\n' "$active" "$occ" > "$tmp" && mv -f "$tmp" "$cache"
}

# Os 10 módulos compartilham o mesmo cache (atualizado no máximo 1x por segundo)
now=$(date +%s)
if [[ ! -s "$cache" ]] || (( $(stat -c %Y "$cache") < now )); then
  refresh
fi

if [[ ! -s "$cache" ]]; then
  # Só o módulo 1 avisa, para não poluir a barra
  [[ "$n" == "1" ]] && printf '{"text":"!","tooltip":"ws.sh: não consegui ler o hyprctl","class":["ws"]}\n' \
                    || printf '{"text":""}\n'
  exit 0
fi

{ read -r active; read -r occ; } < "$cache"

if [[ "$n" == "$active" ]]; then
  printf '{"text":"%s","class":["ws","active"]}\n' "$n"
elif [[ " $occ " == *" $n "* ]]; then
  printf '{"text":"%s","class":["ws","occupied"]}\n' "$n"
else
  printf '{"text":""}\n'   # texto vazio = módulo escondido
fi

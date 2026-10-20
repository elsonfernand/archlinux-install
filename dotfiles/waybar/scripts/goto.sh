#!/usr/bin/env bash
# ~/.config/waybar/scripts/goto.sh N      (N = 1..10, ou e+1 / e-1)
# Troca de workspace usando a sintaxe Lua do Hyprland 0.55+.

hyprctl dispatch "hl.dsp.focus({ workspace = \"$1\" })" >/dev/null

# Atualiza a barra imediatamente (invalida o cache e avisa os módulos)
rm -f "${XDG_RUNTIME_DIR:-/tmp}/waybar-ws.cache"
pkill -RTMIN+8 waybar

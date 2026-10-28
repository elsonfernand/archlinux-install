#!/usr/bin/env bash
# install.sh — instala as dependências e coloca a Waybar em ~/.config/waybar
#
# Uso: deixe este arquivo dentro da pasta "waybar" (junto de config.jsonc,
#      style.css e da pasta scripts/) e rode:
#
#          bash install.sh
#
# Pode ser executado quantas vezes quiser: pacotes já instalados são pulados
# e a configuração anterior é guardada em um backup antes de ser substituída.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"

# ── helpers ──────────────────────────────────────────────────────────────
G=$'\e[32m'; Y=$'\e[33m'; R=$'\e[31m'; N=$'\e[0m'
info() { printf '%s›%s %s\n' "$G" "$N" "$*"; }
warn() { printf '%s!%s %s\n' "$Y" "$N" "$*"; }
die()  { printf '%s✗%s %s\n' "$R" "$N" "$*" >&2; exit 1; }
ask()  { local a; read -rp "$1 [s/N] " a || a=""; [[ "$a" =~ ^[sSyY]$ ]]; }

[[ $EUID -ne 0 ]] || die "Não rode como root. O script usa sudo só quando precisa."

# ── 1) confere se os arquivos estão ao lado do script ────────────────────
for f in config.jsonc style.css \
         scripts/gpu.sh scripts/ssd.sh scripts/ws.sh scripts/goto.sh scripts/ws-watch.py scripts/updates.py; do
  [[ -f "$SRC/$f" ]] || die "Não encontrei '$f' em $SRC. Rode o script dentro da pasta waybar."
done

# ── 2) pacotes ───────────────────────────────────────────────────────────
REQUIRED=(waybar ttf-jetbrains-mono-nerd python wireplumber pipewire-pulse pavucontrol btop kitty pacman-contrib)

if ! command -v pacman >/dev/null 2>&1; then
  warn "pacman não encontrado (o sistema não é Arch?). Pulando a instalação de pacotes."
else
  wanted=()
  for p in "${REQUIRED[@]}"; do
    if [[ $p == pipewire-pulse ]] && pacman -Qq pulseaudio >/dev/null 2>&1; then
      warn "PulseAudio detectado: pulando pipewire-pulse para evitar conflito."
      continue
    fi
    wanted+=("$p")
  done

  # 'pacman -T' lista só o que NÃO está satisfeito (considera pacotes "provides")
  mapfile -t missing < <(pacman -T "${wanted[@]}" || true)

  already=()
  for p in "${wanted[@]}"; do
    [[ " ${missing[*]:-} " == *" $p "* ]] || already+=("$p")
  done
  if ((${#already[@]})); then
    info "Já instalados (pulando): ${already[*]}"
  fi

  if ((${#missing[@]})); then
    info "Instalando: ${missing[*]}"
    sudo pacman -S --needed "${missing[@]}"
  else
    info "Todos os pacotes necessários já estão instalados."
  fi

  # Opcional: tema de ícones para a taskbar
  if ! pacman -Qq papirus-icon-theme >/dev/null 2>&1; then
    if ask "Opcional: instalar papirus-icon-theme (ícones dos programas na taskbar)?"; then
      sudo pacman -S --needed papirus-icon-theme
      info "Dica: para usá-lo, adicione  \"icon-theme\": \"Papirus\"  no bloco wlr/taskbar do config.jsonc."
    fi
  fi
fi

# Aviso sobre o módulo de atualizações (a AUR precisa de um helper)
if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
  warn "Nenhum helper da AUR (yay/paru) encontrado: o módulo de atualizações mostrará só os pacotes oficiais."
fi

# Aviso sobre o módulo de GPU (NVIDIA precisa do nvidia-smi)
if grep -qsi '^0x10de' /sys/class/drm/card*/device/vendor 2>/dev/null \
   && ! command -v nvidia-smi >/dev/null 2>&1; then
  warn "GPU NVIDIA detectada, mas 'nvidia-smi' não foi encontrado. O módulo de GPU precisa do"
  warn "driver proprietário (pacote nvidia-utils); sem ele a barra mostra 'N/D' na GPU."
fi

# ── 3) copia os arquivos para ~/.config/waybar ───────────────────────────
if [[ "$(realpath "$SRC")" == "$(realpath -m "$DEST")" ]]; then
  info "Os arquivos já estão em $DEST, nada a copiar."
else
  # só copia (e faz backup) se algo for diferente do que já está instalado
  changed=0
  for f in config.jsonc style.css; do
    cmp -s "$SRC/$f" "$DEST/$f" 2>/dev/null || changed=1
  done
  for f in "$SRC"/scripts/*; do
    cmp -s "$f" "$DEST/scripts/$(basename "$f")" 2>/dev/null || changed=1
  done

  if ((changed)); then
    if [[ -d "$DEST" && -n "$(ls -A "$DEST")" ]]; then
      BK="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
      cp -a "$DEST" "$BK"
      info "Backup da configuração anterior em: $BK"
    fi
    install -Dm644 "$SRC/config.jsonc" "$DEST/config.jsonc"
    install -Dm644 "$SRC/style.css"    "$DEST/style.css"
    for f in "$SRC"/scripts/*; do
      [[ -f "$f" ]] && install -Dm755 "$f" "$DEST/scripts/$(basename "$f")"
    done
    info "Arquivos instalados em $DEST"
  else
    info "A configuração em $DEST já está atualizada, nada a copiar."
  fi
fi
chmod +x "$DEST"/scripts/*

if [[ "$(realpath -m "$DEST")" != "$(realpath -m "$HOME/.config/waybar")" ]]; then
  warn "O config.jsonc chama os scripts por ~/.config/waybar/scripts/. Como a pasta de destino"
  warn "é outra ($DEST), ajuste esses caminhos no config.jsonc."
fi

# ── 4) reinicia a Waybar (só dentro de uma sessão Hyprland) ──────────────
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && command -v waybar >/dev/null 2>&1; then
  info "Reiniciando a Waybar..."
  pkill -x waybar || true
  sleep 0.5
  setsid -f waybar >/dev/null 2>&1
  info "Pronto!"
else
  info "Pronto! Fora de uma sessão Hyprland a Waybar não foi iniciada:"
  info "ela abre no próximo login, pelo autostart do seu hyprland.lua."
fi

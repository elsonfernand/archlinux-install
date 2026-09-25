#
# ~/.bashrc
#

# Se não for shell interativo, não faz nada
[[ $- != *i* ]] && return

###################################
############# ALIASES #############
###################################

alias ls='eza -lah --icons=auto'
alias grep='grep --color=auto'

alias hyp='[ -z "$WAYLAND_DISPLAY" ] && start-hyprland || echo "Já está em uma sessão Wayland"'

alias i3='[ -z "$DISPLAY" ] && startx || echo "X já está rodando"'

alias sr='source ~/.bashrc && echo ".bashrc recarregado ✔"'

###################################
############### CORES #############
###################################

RESET="\[\e[0m\]"
BOLD="\[\e[1m\]"

FG_USER="\[\e[38;5;45m\]"      # azul claro
FG_HOST="\[\e[38;5;81m\]"      # azul ciano
FG_DIR="\[\e[38;5;110m\]"      # azul acinzentado suave
FG_GOV_PERF="\[\e[31m\]"       # vermelho
FG_GOV_SAVE="\[\e[34m\]"       # azul
FG_GOV_OTHER="\[\e[33m\]"      # amarelo

###################################
########## CPU GOVERNOR ###########
###################################

# Cache simples para evitar leitura repetida do /sys
_gov() {
    local now=$(date +%s)

    if [[ -n "$_GOV_CACHE_TIME" && $((now - _GOV_CACHE_TIME)) -lt 1 ]]; then
        echo -e "$_GOV_CACHE_VALUE"
        return
    fi

    local g=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
    case "$g" in
        performance) _GOV_CACHE_VALUE="${FG_GOV_PERF}⚡ performance${RESET}" ;;
        powersave)   _GOV_CACHE_VALUE="${FG_GOV_SAVE}💤 powersave${RESET}" ;;
        *)           _GOV_CACHE_VALUE="${FG_GOV_OTHER}$g${RESET}" ;;
    esac

    _GOV_CACHE_TIME=$now
    echo -e "$_GOV_CACHE_VALUE"
}

# Alias para mudar governor
alias perf='sudo tuned-adm profile latency-performance && sudo cpupower frequency-set -g performance && echo "🚀 Sistema em modo Áudio/RT"'
alias save='sudo cpupower frequency-set -g powersave && echo "💤 CPU em modo powersave"'
alias gov='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'

###################################
############### PROMPT ############
###################################

PS1="${BOLD}${FG_USER}\u${RESET}@${BOLD}${FG_HOST}\h${RESET} \
${FG_DIR}\w${RESET} ▶ $(_gov)\n\$ "

###################################
############## SYSTEM #############
###################################

# Update todos os pacotes (sem --noconfirm por segurança)
alias upall='sudo pacman -Syu && yay -Sua --devel'

# Update oficial
alias upsys='sudo pacman -Syu'

# Update só AUR
alias upaur='yay -Sua'

# Remove órfãos com segurança
alias clr='orphans=$(pacman -Qtdq); [ -n "$orphans" ] && sudo pacman -Rns $orphans || echo "Nenhum órfão encontrado."'

# Limpa cache de pacotes
alias clrcache='
sudo find /var/cache/pacman/pkg/ -type f -name "download-*" -delete 2>/dev/null
sudo paccache -rk2
yay -Sc --aur --noconfirm
'

unalias maintain 2>/dev/null

maintain() {
  set -e

  echo "==> Atualizando sistema oficial com pacman"
  sudo pacman -Syu

  echo
  echo "==> Atualizando pacotes da AUR com yay"
  yay -Sua --devel

  echo
  echo "==> Removendo pacotes órfãos"
  local orphans
  orphans=$(pacman -Qtdq 2>/dev/null || true)

  if [ -n "$orphans" ]; then
    sudo pacman -Rns $orphans
  else
    echo "Nenhum órfão encontrado."
  fi

  echo
  echo "==> Limpando downloads quebrados do pacman"
  sudo find /var/cache/pacman/pkg/ -type f -name "download-*" -delete 2>/dev/null

  echo
  echo "==> Limpando cache do pacman, mantendo 2 versões"
  sudo paccache -rk2

  echo
  echo "==> Limpando cache da AUR"
  yay -Sc --aur --noconfirm

  echo
  echo "==> Manutenção concluída com sucesso ✔️"
}


###################################
### Desligar, reiniciar, logout ###
###################################

alias sd='systemctl poweroff'
alias rs='systemctl reboot'
alias sp='systemctl suspend'
alias hb='systemctl hibernate'

#Logout i3wm
alias lg='i3-msg exit'

#Logout Hyprland
#alias lh='hyprctl dispatch exit'
alias lh='hyprctl dispatch "hl.dsp.exit()"'

#Logout universal
alias lo='loginctl terminate-session "$XDG_SESSION_ID"'

###################################
########### PROGRAMAS #############
###################################

alias .am='alsamixer'

# Editor padrão
export EDITOR=nano
export VISUAL=nano

###################################
########### WAYLAND/X11 ###########
###################################

# Ajustes conforme sessão
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export QT_QPA_PLATFORM=wayland
    export OZONE_PLATFORM=wayland
else
    export QT_QPA_PLATFORM=xcb
fi

###################################
###### INFO DO SISTEMA (LOGIN) ####
###################################

# Executa o fastfetch apenas em shells interativos
if [[ $- == *i* ]]; then
    fastfetch
fi

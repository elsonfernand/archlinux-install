#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -lah --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1='[\u@\h \W $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)]\$ '

# ----- Colors -----
RESET="\[\e[0m\]"
BOLD="\[\e[1m\]"

FG_USER="\[\e[38;5;45m\]"      # azul claro
FG_HOST="\[\e[38;5;81m\]"      # azul ciano
FG_DIR="\[\e[38;5;110m\]"      # azul acinzentado suave
FG_GOV_PERF="\[\e[31m\]"       # vermelho (performance)
FG_GOV_SAVE="\[\e[34m\]"       # azul (powersave)
FG_GOV_OTHER="\[\e[33m\]"      # amarelo

# ----- Função de governor -----
function _gov() {
    local g=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

    case "$g" in
        performance) echo -e "${FG_GOV_PERF}⚡ performance${RESET}" ;;
        powersave)   echo -e "${FG_GOV_SAVE}💤 powersave${RESET}" ;;
        *)           echo -e "${FG_GOV_OTHER}$g${RESET}" ;;
    esac
}

# ----- Prompt estilo powerline sem background -----
PS1="${BOLD}${FG_USER}\u${RESET}@${BOLD}${FG_HOST}\h${RESET} \
${FG_DIR}\w${RESET} ▶ $(_gov)\n\$ "

###################################
############## System #############
###################################

# Update system and AUR packages automatically
alias upall='sudo pacman -Syu --noconfirm && yay -Sua --noconfirm'

# Update only packages from the official repository automatically
alias upsys='sudo pacman -Syu --noconfirm'

# Update only AUR packages automatically
alias upaur='yay -Sua --noconfirm'

# Clear orphaned packages automatically
alias clr='sudo pacman -Rns $(pacman -Qtdq) --noconfirm'

# Clear cache of old packages automatically
alias clrcache='sudo pacman -Sc --noconfirm && yay -Sc --noconfirm'

###################################
### Desligar, reiniciar, logout ###
###################################

alias sd='systemctl poweroff'   # "sd" de "shutdown"
alias rs='systemctl reboot'     # "rs" de "restart"
alias sp='systemctl suspend'    # "sp" de "suspend"
alias hb='systemctl hibernate'  # "hb" de "hibernate"
#Logout i3wm
alias lg='i3-msg exit'          # "lg" de "logout"
#Logout Hyprland
alias lh='hyprctl dispatch exit'

# Alias para controlar a saída de audio
alias .am='alsamixer'

#Editor
export EDITOR=nano

#Recomendações da página do Wayland
export QT_QPA_PLATFORM=xcb
export QT_QPA_PLATFORM=wayland
export OZONE_PLATFORM=wayland

###################################
########## CPU governor ###########
###################################

alias perf='sudo cpupower frequency-set -g performance && echo "🚀 CPU em modo performance"'
alias save='sudo cpupower frequency-set -g powersave && echo "💤 CPU em modo powersave"'
alias gov='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'

#Informações do sistema
if [ -n "$PS1" ]; then
    fastfetch
fi

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -lah --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# System Update
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

#Cansei de tentar configurar um "powermenu" depois que deixei de usar a i3bar. Tentei na Polybar, no Rofi e recorri a alias mesmo.
alias sd='systemctl poweroff'   # "sd" de "shutdown"
alias rs='systemctl reboot'     # "rs" de "restart"
alias sp='systemctl suspend'    # "sp" de "suspend"
alias hb='systemctl hibernate'  # "hb" de "hibernate"
alias lg='i3-msg exit'          # "lg" de "logout"

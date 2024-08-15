#!/bin/bash

#╭╮╭━┳━━━┳━━━╮╭━╮╭━╮╱╱╱╱╱╱╱╱╱╱╭╮
#┃┃┃╭┻╮╭╮┃╭━━╯┃┃╰╯┃┃╱╱╱╱╱╱╱╱╱╱┃┃
#┃╰╯╯╱┃┃┃┃╰━━╮┃╭╮╭╮┣┳━╮╭┳╮╭┳━━┫┃
#┃╭╮┃╱┃┃┃┃╭━━╯┃┃┃┃┃┣┫╭╮╋┫╰╯┃╭╮┃┃
#┃┃┃╰┳╯╰╯┃╰━━╮┃┃┃┃┃┃┃┃┃┃┃┃┃┃╭╮┃╰╮
#╰╯╰━┻━━━┻━━━╯╰╯╰╯╰┻┻╯╰┻┻┻┻┻╯╰┻━╯

#█▀█ █▀▀ █░░ █▀█ █▀▀ █ █▀█
#█▀▄ ██▄ █▄▄ █▄█ █▄█ █ █▄█
sudo timedatectl set-ntp true
sudo hwclock --systohc

#█▀█ █▀▀ █▀▀ █░░ █▀▀ █▀▀ ▀█▀ █▀█ █▀█
#█▀▄ ██▄ █▀░ █▄▄ ██▄ █▄▄ ░█░ █▄█ █▀▄
# Instalando
sudo pacman -S --noconfirm reflector
# Ativando
sudo systemctl enable reflector.timer
# Configurando
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist


#█▄▀ █▀▄ █▀▀   █▀█ █░░ ▄▀█ █▀ █▀▄▀█ ▄▀█   █▄▄
#█░█ █▄▀ ██▄   █▀▀ █▄▄ █▀█ ▄█ █░▀░█ █▀█   █▄█
# Instalacao do KDE Plasma 6 sem Discover e do gerenciador de login
sudo pacman -S --noconfirm bash-completion fastfetch plasma-desktop pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber nvidia nvidia-utils nvidia-settings dolphin dolphin-plugins ffmpegthumbs ark konsole okular gwenview kscreen kate kde-gtk-config kcalc sddm sddm-kcm --ignore discover

#█▄░█ ▄▀█ █░█ █▀▀ █▀▀ ▄▀█ █▀▄ █▀█ █▀█
#█░▀█ █▀█ ▀▄▀ ██▄ █▄█ █▀█ █▄▀ █▄█ █▀▄
#Desconente a opção que te agradar ou use o Brave
#Chromium, navegador de código aberto (tipo o Google Chrome mas sem o dedo do Google)
#sudo pacman -S --noconfirm chromium
#Firefox, navegador altamente difundido nas mais variadas distribuições
#sudo pacman -S --noconfirm firefox
#█▄▄ █▀█ ▄▀█ █░█ █▀▀   █▄▄ █▀█ █▀█ █░█░█ █▀ █▀▀ █▀█
#█▄█ █▀▄ █▀█ ▀▄▀ ██▄   █▄█ █▀▄ █▄█ ▀▄▀▄▀ ▄█ ██▄ █▀▄
# Caso queira instalar o Brave (navegador de código aberto, com bloqueador de anúncios embutido e baseado no Chromium) sem ajudante do AUR #
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm
cd ..
rm -rf brave-bin

#▀█▀ █░░ █▀█
#░█░ █▄▄ █▀▀
# Instalando e ativando o servico de melhoria da bateria para notebooks.
sudo pacman -S --noconfirm tlp
sudo systemctl enable --now tlp

#█▀ █▀▄ █▀▄ █▀▄▀█
#▄█ █▄▀ █▄▀ █░▀░█
# Ativando o gerenciador de login SDDM
sudo systemctl enable --now sddm

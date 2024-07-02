#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

## Reflector
# Instalando
pacman -S --noconfirm reflector
# Ativando
systemctl enable reflector.timer
# Configurando
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Instalação do KDE Plasma 6 sem Discover e do gerenciador de login
sudo pacman -S --noconfirm bash-completion fastfetch plasma-desktop git pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber nvidia nvidia-utils nvidia-settings dolphin dolphin-plugins ffmpegthumbs ark konsole okular gwenview kscreen chromium kate kde-gtk-config kcalc sddm sddm-kcm --ignore discover

# Download e instalação do yay
sudo pacman -S git go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Instalando e ativando a SWAP
yay -S --noconfirm zramd
sudo systemctl enable --now zramd.service
echo "ALGORITHM=zstd" >> /etc/default/zramd
echo "MAX_SIZE=8192" >> /etc/default/zramd

# Ativando o SDDM
systemctl enable --now sddm

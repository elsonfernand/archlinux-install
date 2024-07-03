#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

## Reflector
# Instalando
sudo pacman -S --noconfirm reflector
# Ativando
sudo systemctl enable reflector.timer
# Configurando
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Instalação do KDE Plasma 6 sem Discover e do gerenciador de login
sudo pacman -S --noconfirm bash-completion fastfetch plasma-desktop git pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber nvidia nvidia-utils nvidia-settings dolphin dolphin-plugins ffmpegthumbs ark konsole okular gwenview kscreen chromium kate kde-gtk-config kcalc sddm sddm-kcm --ignore discover

# Instalando e ativando o serviço de melhoria da bateria para notebooks.
sudo pacman -S --noconfirm tlp
sudo systemctl enable --now tlp

# Download e instalação do yay
sudo pacman -S git go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Instalando e ativando a SWAP
yay -S --noconfirm zramd
sudo systemctl enable --now zramd.service

# Pacotes e ativação da impressora Epson L3150
# sudo pacman -S --noconfirm cups ghostscript gsfonts libcups gutenprint foomatic-db-gutenprint-ppds
# sudo systemctl enable --now cups.service ; sudo systemctl enable --now cups.socket ; sudo systemctl enable --now cups.path
# sudo pacman -S --noconfirm system-config-printer
# sudo usermod -aG lp $USER
# sudo pacman -S sane-airscan sane ipp-usb
# sudo usermod -aG saned,scanner $USER
# sudo systemctl enable --now ipp-usb.service
# sudo pacman -S simple-scan
# yay -S epson-inkjet-printer-escpr epsonscan2 imagescan-plugin-networkscan

# Ativando o SDDM
sudo systemctl enable --now sddm

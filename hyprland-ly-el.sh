#!/bin/bash

set -e  # Interrompe o script em caso de erro

# Atualização do sistema
echo "Atualizando o sistema..."
sudo pacman -Syu --noconfirm

# Pacotes essenciais
echo "Instalando pacotes essenciais..."
sudo pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland xorg-xwayland waybar wofi \
    thunar tumbler libopenraw webp-pixbuf-loader imagemagick gtk-engine-murrine \
    gtk-engines gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc gvfs-nfs gvfs-smb \
    numlockx telegram-desktop network-manager-applet pulseaudio-alsa \
    grim slurp wl-clipboard libgsf swappy dunst polkit-kde-agent \
    xdg-utils poppler poppler-glib ffmpegthumbnailer nwg-look

# Display Manager
sudo pacman -S --noconfirm ly

# Pacotes de áudio
sudo pacman -S --noconfirm pipewire wireplumber pipewire-pulse alsa-utils pavucontrol 

# Emulador de terminal
sudo pacman -S --noconfirm alacritty 

# Habilitar o NetworkManager
echo "Habilitando o NetworkManager..."
sudo systemctl enable --now NetworkManager

# Habilitar o Ly como display manager
echo "Habilitando o Ly como display manager..."
sudo systemctl enable ly

# Criando diretórios essenciais
echo "Criando diretórios essenciais..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi

# Configuração básica do Hyprland
echo "Configurando o Hyprland..."
sudo cp /usr/share/hypr/hyprland.conf $HOME/.config/hypr/

# Permissões corretas
echo "Ajustando permissões..."
chmod +x ~/.config/hypr/hyprland.conf

# Mensagem final
echo "Instalação concluída! Reinicie o sistema e o Ly será iniciado automaticamente."

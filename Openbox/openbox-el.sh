#!/bin/bash

# Atualiza o sistema:
sudo pacman -Syu --noconfirm

# Instalacao do Openbox, LightDM, PCManFM e alguns pacotes adicionais:
sudo pacman -S --noconfirm openbox obconf lxappearance-obconf tint2 archlinux-wallpaper xorg-server xorg-xinit lightdm lightdm-gtk-greeter pcmanfm-qt gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc lxterminal menumaker arandr nano chromium vlc fastfetch engrampa

# Instalando o PipeWire
yes | sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol 

## Instalando o Yay: ##
yes | sudo pacman -S git go base-devel
# Baixando o código fonte:
git clone https://aur.archlinux.org/yay.git
# Acessando a pasta:
cd yay
# Compilando:
yes | makepkg -si
# Indo para a home
cd

# Instalando o GUI para configuração do menu do Openbox
# yes | yay obmenu

# Habilitando e iniciando o PipeWire e WirePlumber
sudo systemctl enable --now pipewire.service
sudo systemctl enable --now wireplumber.service

# Habilitando o LightDM (gerenciador de login)
sudo systemctl enable lightdm.service

# Escolha do driver de video
echo "Escolha o driver de video para instalar:"
echo "1) AMD"
echo "2) Nvidia"
echo "3) VirtualBox"
read -p "Digite o numero da sua escolha: " driver_choice

case $driver_choice in
  1)
    sudo pacman -S --noconfirm xf86-video-amdgpu
    ;;
  2)
    sudo pacman -S --noconfirm nvidia nvidia-utils
    ;;
  3)
    sudo pacman -S --noconfirm virtualbox-guest-utils
    sudo systemctl enable --now vboxservice
    ;;
  *)
    echo "Escolha invalida. Nenhum driver de video sera instalado."
    ;;
esac


# Criacao de diretorios de configuracao do Openbox
mkdir -p ~/.config/openbox

# Criacao do arquivo de configuracao basico do Openbox
cat <<EOL > ~/.config/openbox/autostart
# Barra de tarefas Tint2
tint2 &

# Gerenciador de área de transferência
parcellite &

# Papel de parede
nitrogen --restore &

# Aparência do GTK e configurações do Openbox
lxappearance-obconf &
EOL

# Criacao de um arquivo de sessao do Openbox para o LightDM
sudo mkdir -p /usr/share/xsessions
sudo tee /usr/share/xsessions/openbox.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Openbox
Comment=Log in using Openbox
Exec=openbox-session
TryExec=openbox-session
Icon=openbox
Type=Application
EOL

# Configuracao do PCManFM para suportar visualização de miniaturas de arquivos
mkdir -p ~/.config/pcmanfm/default
cat <<EOL > ~/.config/pcmanfm/default/pcmanfm.conf
[config]
show_hidden=1
sort_by=name
view_mode=2
show_thumbs=1
EOL

# Reconfiguração automática do menu do Openbox usando Menumaker
mmaker -vf openbox

printf "\033[0mInstalação do \033[01;37mOpenbox\033[0m concluída. Reinicie o sistema para iniciar o LightDM."

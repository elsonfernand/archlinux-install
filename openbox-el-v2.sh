#!/bin/bash

# Create the necessary folders for Openbox configuration
mkdir -p ~/.config/openbox
mkdir -p ~/.config/pcmanfm
mkdir -p ~/.config/pipewire

# Instalacao do Openbox com algumas dependencias
sudo pacman -S --noconfirm openbox obconf

# Instalacao do LightDM com algumas dependencias
sudo pacman -S --noconfirm lightdm lightdm-slick-greeter

# Instalacao do PCManFM com algumas dependencias
sudo pacman -S --noconfirm pcmanfm

# Instalacao do PipeWire com algumas dependencias
sudo pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa

# Instalação drivers placa de video AMD
#sudo pacman -S --noconfirm xf86-video-amdgpu
# Instalação drivers placa de video Nvidia
#sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# Instalação e habilitacao drivers para o VirtualBox
#sudo pacman -S --noconfirm virtualbox-guest-utils
#sudo systemctl enable --now vboxservice

# Instalacao de alguns pacotes necessarios para customizacao com GUI
sudo pacman -S --noconfirm \
  obtheme \
  lxappearance-obconf \
  gtk-chtheme \
  gtk-engine-murrine \
  gtk-engines \
  faenza-icon-theme \
  oxygen-icons \
  numix-icon-theme-circle \
  arc-gtk-theme \
  moka-icon-theme \
  paper-icon-theme \
  qt5-styleplugins \
  qt5ctt \
  menumaker

# Instalacao de todas as ferramentas de customizacao disponiveis no repositorio oficial e multilib
sudo pacman -S --noconfirm $(pacman -Slq | grep -E 'openbox|lightdm|pcmanfm|pipewire')

# Criacao de arquivos necessarios para configuracao do Openbox
touch ~/.config/openbox/autostart
touch ~/.config/openbox/environment
touch ~/.config/openbox/menu.xml
touch ~/.config/openbox/rc.xml

# Criacao de arquivos necessarios para configuracao do PCManFM
touch ~/.config/pcmanfm/default.conf

# Criacao de arquivos necessarios para configuracao do PipeWire
touch ~/.config/pipewire/pipewire.conf

# Configuracao do LightDM utilizando o slick-greeter
echo "[Seat:*]" >> ~/.config/lightdm/lightdm.conf
echo "greeter-session=lightdm-slick-greeter" >> ~/.config/lightdm/lightdm.conf

# Por padrão o Openbox não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem:
yes | sudo pacman -S xdg-user-dirs ; xdg-user-dirs-update

# Reconfiguração automática do menu do Openbox usando Menumaker
mmaker -vf openbox

# Habilitando e iniciando o PipeWire
sudo systemctl enable pipewire
sudo systemctl start pipewire

# Habilitando e iniciando o LightDM
sudo systemctl enable lightdm

printf "\033[0mInstalação do \033[01;37mOpenbox\033[0m concluída. Reinicie o sistema para iniciar o LightDM."

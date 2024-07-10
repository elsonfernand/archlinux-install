#!/bin/bash

# Create the necessary folders for Openbox configuration
mkdir -p ~/.config/openbox
mkdir -p ~/.config/pcmanfm
mkdir -p ~/.config/pipewire

# Instalacao do Openbox com algumas dependencias
sudo pacman -S openbox obconf obmenu-generator

# Instalacao do LightDM com algumas dependencias
sudo pacman -S lightdm lightdm-slick-greeter

# Instalacao do PCManFM com algumas dependencias
sudo pacman -S pcmanfm

# Instalacao do PipeWire com algumas dependencias
sudo pacman -S pipewire pipewire-pulse pipewire-alsa

# Instalacao de alguns pacotes necessarios para customizacao com GUI
sudo pacman -S \
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
  qt5ct

# Instalacao de todas as ferramentas de customizacao disponiveis no repositorio oficial e multilib
sudo pacman -S $(pacman -Slq | grep -E 'openbox|lightdm|pcmanfm|pipewire')

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

# Habilitando e iniciando o LightDM
sudo systemctl enable lightdm
sudo systemctl start lightdm

# Habilitando e iniciando o PipeWire
sudo systemctl enable pipewire
sudo systemctl start pipewire

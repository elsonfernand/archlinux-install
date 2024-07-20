#!/bin/bash

# Atualizar o sistema
sudo pacman -Syu --noconfirm

# Instalar dependências para AUR
sudo pacman -S git base-devel --noconfirm

sudo pacman -S --noconfirm cups ghostscript gsfonts libcups gutenprint foomatic-db-gutenprint-ppds boost cmake rapidjson

# Iniciar e habilitar os serviços necessarios
sudo systemctl enable --now cups.service ; sudo systemctl enable --now cups.socket ; sudo systemctl enable --now cups.path

# Baixar utilitário de configuração de impressora com GUI
sudo pacman -S --noconfirm system-config-printer

# Adicionar usuário ao grupo lp
sudo usermod -aG lp $USER

# Suporte a digitalização sem driver
sudo pacman -S --noconfirm sane-airscan sane ipp-usb

# Adicionar usuário aos grupos saned e scanner 
sudo usermod -aG saned,scanner $USER

# Serviço para que a impressora também possa ser usada com USB
sudo systemctl enable --now ipp-usb.service

# Utilitário para escanear documentos
sudo pacman -S --noconfirm simple-scan

# Baixar e instalar o driver Epson do AUR
git clone https://aur.archlinux.org/epson-inkjet-printer-escpr2.git
cd epson-inkjet-printer-escpr2
yes | makepkg -si
cd ..

# Baixar e instalar o utilitário Epson do AUR
git clone https://aur.archlinux.org/epson-printer-utility.git
cd epson-printer-utility
yes | makepkg -si
cd ..

# Baixar e instalar o utilitário Imagescan Plugin Networkscan
git clone https://aur.archlinux.org/qt5-singleapplication.git
cd qt5-singleapplication
yes | makepkg -si
cd ..

# Baixar e instalar o utilitário Imagescan Plugin Networkscan
git clone https://aur.archlinux.org/epsonscan2.git
cd epsonscan2
yes | makepkg -si
cd ..


# Baixar e instalar o utilitário Imagescan Plugin Networkscan
git clone https://aur.archlinux.org/imagescan-plugin-networkscan.git
cd imagescan-plugin-networkscan
yes | makepkg -si
cd ..

echo "Configuração concluída. Reinicie o sistema para garantir que todas as alterações tenham efeito."

#!/bin/bash

# Se certificando que tem o "git", "go" e "base-devel" estao instalados
yes | sudo pacman -S git go base-devel
# Baixando o código fonte:
git clone https://aur.archlinux.org/yay.git
# Acessando a pasta:
cd yay
# Compilando:
yes | makepkg -si
# Indo para a home
cd

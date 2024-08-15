#!/bin/bash

#╭━━━╮╱╱╱╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮╭╮╱╱╱╱╱╱╱╱╱╭╮╱╱╱╱
#┃╭━╮┃╱╱╱╱╱╱╱╭╯╰╮╱╱╱╱╱╱╱╱╱╱╱╱╱┃┣╯╰╮╱╱╱╱╱╱╱╱┃┃╱╱╱╱
#┃╰━╯┣━━┳━━┳━┻╮╭╋━━┳━━╮╱╭╮╭┳╮╭┫┣╮╭╋┳╮╭┳━━┳━╯┣┳━━╮
#┃╭━━┫╭╮┃╭━┫╭╮┃┃┃┃━┫━━┫╱┃╰╯┃┃┃┃┃┃┃┣┫╰╯┃┃━┫╭╮┣┫╭╮┃
#┃┃╱╱┃╭╮┃╰━┫╰╯┃╰┫┃━╋━━┃╱┃┃┃┃╰╯┃╰┫╰┫┃┃┃┃┃━┫╰╯┃┃╭╮┃
#╰╯╱╱╰╯╰┻━━┻━━┻━┻━━┻━━╯╱╰┻┻┻━━┻━┻━┻┻┻┻┻━━┻━━┻┻╯╰╯

# Atualizacao do sistema
sudo pacman -Syu

#█▄▀ █▀▄ █▀▀ █▄░█ █░░ █ █░█ █▀▀
#█░█ █▄▀ ██▄ █░▀█ █▄▄ █ ▀▄▀ ██▄
#Para que o Kdenlive tenha uma interface bonitinha tem que ser instalado o tema "breeze"
sudo pacman -S --noconfirm breeze kdenlive

#█▀▄ █▀▀ █▀ █ █▀▀ █▄░█  █▀▀ █▀█ ▄▀█ █▀▀ █ █▀▀ █▀█
#█▄▀ ██▄ ▄█ █ █▄█ █░▀█  █▄█ █▀▄ █▀█ █▀░ █ █▄▄ █▄█
# Instalacao de pacotes design gráfico. Exclua os tres ultimos pacotes se nao for lidar com imagens RAW.
sudo pacman -S --noconfirm inkscape scribus gimp blender darktable opencl-nvidia opencl-headers font-manager

#▄▀█ █░█ █▀▄ █ █▀█
#█▀█ █▄█ █▄▀ █ █▄█
# Instalacao audio: gravacao de guitarra e sugestoes de plugins (Ardour para gravacao, o Guitarix apenas para fazer um som e o resto sao plugins)
sudo pacman -S --noconfirm ardour guitarix gxplugins.lv2 lv2 carla x42-plugins avldrums.lv2 lsp-plugins-lv2 calf noise-repellent dragonfly-reverb-lv2 master_me-lv2 eq10q gmsynth.lv2 zam-plugins-lv2 

#█ █▀█   █░░ █▀█ ▄▀█ █▀▄ █▀▀ █▀█
#█ █▀▄   █▄▄ █▄█ █▀█ █▄▀ ██▄ █▀▄
# Plugin carregador de IR e mixer de modelo neural para Linux/Windows.
git clone https://github.com/brummer10//Ratatouille.lv2.git
cd Ratatouille.lv2
git submodule update --init --recursive
make
# make install # will install into ~/.lv2 ... AND/OR....
sudo make install # will install into /usr/lib/lv2

# Caso já esteja com uma interface grafica instalada recomendo o pacote de IR gratuito GuitarHack Impulses que se encontra no link para copiar e colar no navegador de sua preferencia: https://my.pcloud.com/publink/show?code=XZIK5QkZMpbl49KMeHQy3dmnzMTPojdJSReX

#█▀▀ █▀▄ █ ▀█▀ █▀█ █▀█   █▀▄ █▀▀   ▀█▀ █▀▀ ▀▄▀ ▀█▀ █▀█
#██▄ █▄▀ █ ░█░ █▄█ █▀▄   █▄▀ ██▄   ░█░ ██▄ █░█ ░█░ █▄█
sudo pacman -S --noconfirm libreoffice-still

echo "Instalação dos pacotes necessários para começar a trabalhar está concluída."
echo "Se você executou esse script antes de instalar um ambiente de trabalho, já pode reniciar o sistema."
echo "Caso contrário pode começar a fazer dinheiro. kkkkk"

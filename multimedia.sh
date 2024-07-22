#!/bin/bash

# Atualizacao do sistema
sudo pacman -Syu

#Para que o Kdenlive tenha uma interface bonitinha tem que ser instalado o tema "breeze"
sudo pacman -S --noconfirm breeze

# Instalacao de pacotes design gráfico. Exclua os tres ultimos pacotes se nao for lidar com imagens RAW.
sudo pacman -S --noconfirm kdenlive inkscape scribus gimp blender darktable opencl-nvidia opencl-headers 

# Instalacao audio: gravacao de guitarra e sugestoes de plugins (Ardour para gravacao, o Guitarix apenas para fazer um som e o resto sao plugins)
sudo pacman -S --noconfirm ardour guitarix gxplugins.lv2 lv2 carla x42-plugins avldrums.lv2 lsp-plugins-lv2 calf noise-repellent dragonfly-reverb-lv2 master_me-lv2 eq10q gmsynth.lv2 zam-plugins-lv2 

# Caso já esteja com uma interface grafica instalada recomendo o pacote de IR gratuito GuitarHack Impulses que se encontra no link para copiar e colar no navegador de sua preferencia: https://my.pcloud.com/publink/show?code=XZIK5QkZMpbl49KMeHQy3dmnzMTPojdJSReX

# Instalacao de editor de texto
sudo pacman -S --noconfirm libreoffice-still

echo "Instalação dos pacotes necessários para começar a trabalhar está concluída."
echo "Se você executou esse script antes de instalar um ambiente de trabalho, já pode reniciar o sistema."
echo "Caso contrário pode começar a fazer dinheiro. kkkkk"

#!/bin/bash

#################### INICIO DO SCRIPT ####################

#Atualizando os servers:
sudo pacman -Syy

# Pacotes iniciais para instalacao do Openbox, mas nem todos sao essenciais:
sudo pacman -S --noconfirm openbox cairo-dock obconf nitrogen gedit xterm lxterminal lightdm lightdm-slick-greeter mate-polkit screen volumeicon arandr nano chromium vlc lxappearance libreoffice-still fastfetch engrampa

# Instalação do servidor de audio Pipewire:
yes | sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Instalacao de um gerenciador de arquivos. Aqui estarei usando o Thunar (e adicionando alguns pacotes para melhor configuracao):
sudo pacman -S --noconfirm thunar libgsf ffmpegthumbnailer evince gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc tumbler poppler-glib freetype2 libgsf unzip ntfs-3g

# Instalacao dos drivers da Nvidia:
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# Descomente a opcao abaixo se você usa placa de vídeo da ADM.
# pacman -S --noconfirm xf86-video-amdgpu

# Agora a gente precisa copiar o .xinirc no diretorio do X11 para o diretorio /home:
cp /etc/X11/xinit/xinitrc .xinitrc

# Adicionando a linha para que o Openbox inicie, mas voce precisa verificar e/ou alterar o arquivo caso algum erro ocorra:
echo "exec openbox-session" >> .xinitrc

# Alterando o layout de teclado
setxkbmap -model abnt2 br

# Criando um diretorio para o Openbox:
mkdir -p ~/.config/openbox

#Passo inicial para comecar a configuracao:
cp -a /etc/xdg/openbox ~/.config/

# Por padrão o Openbox não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem:
sudo pacman -S xdg-user-dirs ; xdg-user-dirs-update

# Habilitando o LightDM
sudo systemctl enable lightdm.service

# Criando um arquivo de inicializacao
cd ..
cd ~/.config
mkdir openbox
cd

printf "\033[00;37mPronto! Agora você pode reiniciar o sistema digitando \033[01;37reboot\033[00;37m!"

#################### FIM DO SCRIPT ####################

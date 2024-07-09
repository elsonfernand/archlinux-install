#!/bin/bash

# Atualiza o sistema:
sudo pacman -Syu --noconfirm

# Instalacao do Openbox, LightDM, PCManFM e alguns pacotes adicionais:
sudo pacman -S --noconfirm openbox obconf obmenu lxappearance tint2 archlinux-wallpaper xorg-server xorg-xinit lightdm lightdm-gtk-greeter pcmanfm gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc lxterminal pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol menumaker

# Habilitando e iniciando o PipeWire e WirePlumber
sudo systemctl enable --now pipewire.service
sudo systemctl enable --now wireplumber.service

# Habilitando o LightDM (gerenciador de login)
sudo systemctl enable lightdm.service

# Criacao de diretorios de configuracao do Openbox
mkdir -p ~/.config/openbox

# Criacao do arquivo de configuraçcao basico do Openbox
cat <<EOL > ~/.config/openbox/autostart
# Barra de tarefas Tint2
tint2 &

# Gerenciador de área de transferência
parcellite &

# Papel de parede
nitrogen --restore &

# Aparência do GTK
lxappearance &
EOL

# Criacao de um arquivo de sessão do Openbox para o LightDM
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

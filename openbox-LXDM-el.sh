#!/bin/bash

#################################################################################
#################################################################################
###### Você deve ficar de olho para saber o que esse script está fazendo, #######
###### ele atente apenas as minhas necessidades em uma instalação inicial #######
#################################################################################
#################################################################################

# Atualiza o sistema #
sudo pacman -Syu

# Instala o Openbox e algumas ferramentas básicas #
sudo pacman -S openbox xorg-xinit xorg obconf

# Instala ferramentas de mudança de wallpaper e resolução de tela #
sudo pacman -S nitrogen arandr

# Instala emuladores de terminal #
sudo pacman -S xterm lxterminal

# Instala ferramentas de tema e ícones do Openbox #
sudo pacman -S lxappearance-obconf

# Instala barra de tarefas e aplicativos básicos #
sudo pacman -S tint2 volumeicon network-manager-applet xfce4-power-manager

# Instala utilitários adicionais e gerenciador de arquivos #
sudo pacman -S pcmanfm gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc menumaker tumbler ffmpegthumbnailer xarchiver vlc archlinux-wallpaper fastfetch

# Instalando PipeWire e alguns pacotes relevantes #
yes | sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol qpwgraph

# Habilita e iniciar os serviços do PipeWire #
systemctl --user enable pipewire.service
systemctl --user start pipewire.service

systemctl --user enable pipewire-pulse.service
systemctl --user start pipewire-pulse.service

systemctl --user enable wireplumber.service
systemctl --user start wireplumber.service

# Instala gerenciador de login LXDM #
sudo pacman -S lxdm-gtk3 

# Configurar LXDM para iniciar a sessão do Openbox #
sudo sed -i 's/^# session=.*/session=\/usr\/bin\/openbox-session/' /etc/lxdm/lxdm.conf

# Configurações adicionais recomendadas pela wiki do LXDM #
sudo sed -i 's/^# numlock=.*/numlock=0/' /etc/lxdm/lxdm.conf
# sudo sed -i 's/^# default_lang=.*/default_lang=en_US.UTF-8/' /etc/lxdm/lxdm.conf
# sudo sed -i 's/^# skip_password=.*/skip_password=0/' /etc/lxdm/lxdm.conf
# sudo sed -i 's/^# hide=.*/hide=/' /etc/lxdm/lxdm.conf
# sudo sed -i 's/^# autologin=.*/autologin=/' /etc/lxdm/lxdm.conf
# sudo sed -i 's/^# timeout=.*/timeout=10/' /etc/lxdm/lxdm.conf

# Configurar layout de teclado para br-abnt2 no LXDM #
sudo sed -i 's/^# keyboard=.*/keyboard=br-abnt2/' /etc/lxdm/lxdm.conf

# Habilita o LXDM para iniciar no boot #
sudo systemctl enable lxdm.service

# Cria diretórios necessários para funcionamento do Openbox #
mkdir -p ~/.config/openbox
mkdir -p ~/.config/tint2

# Instalação de drivers de vídeo #
# Nvidia #
sudo pacman -S nvidia nvidia-utils nvidia-settings
# AMD #
# sudo pacman -S xf86-video-amdgpu
# VirtualBox #
# sudo pacman -S virtualbox-guest-utils
# systemctl enable vboxservice.service

# Cria atalho para iniciar o Openbox #
echo "exec openbox-session" > ~/.xinitrc

# Por padrão o Openbox não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem: #
yes | sudo pacman -S xdg-user-dirs ; xdg-user-dirs-update

# Reconfiguração automática do menu do Openbox usando Menumaker #
mmaker -vf openbox

# Configurar o layout de teclado padrão como br-abnt2 no sistema
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

# Cria arquivos de configuração padrão do Openbox #
cat <<EOL > ~/.config/openbox/autostart
# Iniciar ferramentas no login
tint2 &
volumeicon &
nm-applet &
xfce4-power-manager &
nitrogen --restore &
EOL

# Finaliza a instalação e configuração
echo "Instalação e configuração inicial do Openbox concluídas. Reinicie o sistema ou faça logout para começar a usar."

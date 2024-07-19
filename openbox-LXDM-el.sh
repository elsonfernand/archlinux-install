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
sudo pacman -S --noconfirm openbox xorg-xinit xorg obconf

# Instalando PipeWire e alguns pacotes relevantes ao aoudio #
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol qpwgraph

# Instala ferramentas de mudança de wallpaper e resolução de tela #
sudo pacman -S --noconfirm nitrogen arandr

# Instala emuladores de terminal #
sudo pacman -S --noconfirm xterm lxterminal

# Instala ferramentas de tema e ícones do Openbox #
sudo pacman -S --noconfirm lxappearance-obconf

# Instala barra de tarefas e aplicativos básicos #
sudo pacman -S --noconfirm tint2 volumeicon network-manager-applet xfce4-power-manager gsimplecal 

# Instala utilitários adicionais e gerenciador de arquivos #
sudo pacman -S --noconfirm pcmanfm gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc menumaker tumbler ffmpegthumbnailer unzip xarchiver vlc archlinux-wallpaper fastfetch picom libxml2 wget curl zathura leafpad scrot

# Instala navegador. Descomente a linha da sua preferencia, pois eu uso navegador baseado no Chromium. #
sudo pacman -S --noconfirm chromium
#sudo pacman -S --noconfirm firefox

# Habilita e iniciar os serviços do PipeWire #
systemctl --user enable pipewire.service
systemctl --user start pipewire.service

systemctl --user enable pipewire-pulse.service
systemctl --user start pipewire-pulse.service

systemctl --user enable wireplumber.service
systemctl --user start wireplumber.service

# Instala gerenciador de login LXDM #
sudo pacman -S --noconfirm lxdm-gtk3 

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
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# AMD #
# sudo pacman -S --noconfirm xf86-video-amdgpu
# VirtualBox #
# sudo pacman -S --noconfirm virtualbox-guest-utils
# systemctl enable vboxservice.service

# Cria atalho para iniciar o Openbox #
echo "exec openbox-session" > ~/.xinitrc

# Por padrão o Openbox não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem: #
sudo pacman -S --noconfirm xdg-user-dirs ; xdg-user-dirs-update

# Reconfiguração automática do menu do Openbox usando Menumaker #
mmaker -vf openbox

# Configurar o layout de teclado padrão como br-abnt2 no sistema
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

# Instala alguns temas e cursores #
sudo pacman -S --noconfirm arc-gtk-theme lxde-icon-theme materia-gtk-theme lxqt-themes papirus-icon-theme xcursor-vanilla-dmz xcursor-vanilla-dmz-aa

##############################################################
### INSTALANDO E ATIVANDO O NUMLOCK NO TTY, LXDM E OPENBOX ###
##############################################################

# Instalando numlockx
sudo pacman -S --noconfirm numlockx

# Configurando numlock no tty
sudo bash -c 'echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf'
sudo bash -c 'cat << EOF > /etc/systemd/system/numlock.service
[Unit]
Description=Activate numlock on boot

[Service]
ExecStart=/usr/bin/setleds +num < /dev/tty1

[Install]
WantedBy=multi-user.target
EOF'
sudo systemctl enable numlock.service

# Configurando numlock no LXDM
sudo sed -i '/^\[base\]/a numlock=1' /etc/lxdm/lxdm.conf

# Configurando numlock no Openbox
if grep -q 'numlockx on &' ~/.config/openbox/autostart; then
    echo "Numlock already configured in Openbox autostart."
else
    echo "numlockx on &" >> ~/.config/openbox/autostart
fi

if grep -q 'numlockx on &' ~/.xinitrc; then
    echo "Numlock already configured in .xinitrc."
else
    echo "numlockx on &" >> ~/.xinitrc
fi

#############################################################################
### FINALIZACAO DA INSTALACAO E ATIVACAO O NUMLOCK NO TTY, LXDM E OPENBOX ###
#############################################################################

# Cria arquivos de configuração padrão do Openbox #
cat <<EOL > ~/.config/openbox/autostart
# Iniciar ferramentas no login
tint2 &
volumeicon &
nm-applet &
xfce4-power-manager &
nitrogen --restore &
picom -f &
EOL

# Configuração do Picom para efeitos de composição #
mkdir -p ~/.config/picom
cat <<EOL > ~/.config/picom/picom.conf
# Configuração básica
backend = "glx";
glx-no-stencil = true;
glx-no-rebind-pixmap = true;
vsync = "opengl-swc";
EOL

# Finaliza a instalação e configuração
echo "Instalação e configuração inicial do Openbox concluídas. Reinicie o sistema para começar a usar."

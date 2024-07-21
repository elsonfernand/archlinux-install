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

# Instala ferramentas de mudança de wallpaper #
sudo pacman -S --noconfirm nitrogen

# Instala emuladores de terminal #
sudo pacman -S --noconfirm xterm lxterminal

# Instala ferramentas de tema e ícones do Openbox #
sudo pacman -S --noconfirm lxappearance-obconf

# Instala barra de tarefas e aplicativos básicos #
sudo pacman -S --noconfirm tint2 volumeicon network-manager-applet xfce4-power-manager gsimplecal 

# Instala utilitários adicionais e gerenciador de arquivos #
sudo pacman -S --noconfirm pcmanfm gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc menumaker tumbler ffmpegthumbnailer unzip xarchiver vlc archlinux-wallpaper fastfetch picom libxml2 wget curl zathura leafpad

# Instala navegador. Descomente a linha da sua preferencia. Eu dou preferencia a navegador baseado no Chromium. #
#sudo pacman -S --noconfirm chromium
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
sudo sed -i 's/^# numlock=.*/numlock=1/' /etc/lxdm/lxdm.conf
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

# Configurar o layout de teclado padrão como br-abnt2 no sistema
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

# Instala alguns temas, cursores e fontes #
sudo pacman -S --noconfirm arc-gtk-theme lxde-icon-theme materia-gtk-theme lxqt-themes papirus-icon-theme xcursor-vanilla-dmz xcursor-vanilla-dmz-aa noto-fonts-emoji ttf-dejavu ttf-liberation

#######################################
## Instalação e configuração do Rofi ##
#######################################
# Atualiza os repositórios e instala o rofi
sudo pacman -Syu --noconfirm rofi

# Configurações de Locale
echo "Configurando locales..."
# Descomenta en_US.UTF-8 no arquivo locale.gen
sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

# Gera os locales
sudo locale-gen

# Configura o locale padrão
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
echo 'LC_ALL=en_US.UTF-8' | sudo tee -a /etc/locale.conf

# Exporta as variáveis de locale para a sessão atual
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Adiciona as variáveis de locale ao .bashrc para garantir que sejam configuradas em cada sessão
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
source ~/.bashrc

echo "Locales configurados."

# Cria o diretório de configuração do Openbox, se não existir
mkdir -p ~/.config/openbox

# Cria o diretório de configuração do rofi, se não existir
mkdir -p ~/.config/rofi

# Adiciona configuração para mostrar ícones no rofi
cat <<EOL > ~/.config/rofi/config.rasi
configuration {
    show-icons: true;
}
EOL

# Recarrega as configurações do Openbox
openbox --reconfigure

##############################################
## Fim da instalação e configuração do Rofi ##
##############################################

#########################################
## INSTALAÇÃO E CONFIGURAÇÃO DO ARANDR ##
#########################################
# Atualiza o sistema e instala o Arandr
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm arandr

# Cria o diretório para o script de configuração do xrandr se não existir
mkdir -p ~/.config/openbox

# Cria o script de configuração do xrandr
cat <<EOL > ~/.config/openbox/monitor_layout.sh
#!/bin/bash

# Configuração do xrandr para dois monitores
# Monitor secundário à esquerda
xrandr --output HDMI-1 --primary --auto --output HDMI-2 --auto --left-of HDMI-1
EOL

# Torna o script executável
chmod +x ~/.config/openbox/monitor_layout.sh

# Adiciona a execução do script no arquivo autostart do Openbox
if ! grep -q "~/.config/openbox/monitor_layout.sh" ~/.config/openbox/autostart; then
    echo "~/.config/openbox/monitor_layout.sh" >> ~/.config/openbox/autostart
fi

################################################
## FIM DA INSTALAÇÃO E CONFIGURAÇÃO DO ARANDR ##
################################################

##########################################
### CONFIGURAÇÃO DO ARANDR PARA O LXDM ###
##########################################
# Adiciona a configuração do xrandr para o LXDM
sudo mkdir -p /etc/X11/xinit/xinitrc.d
cat <<EOL | sudo tee /etc/X11/xinit/xinitrc.d/10-monitor_layout.sh > /dev/null
#!/bin/bash

# Configuração do xrandr para dois monitores
# Monitor secundário à esquerda
xrandr --output HDMI-1 --primary --auto --output HDMI-2 --auto --left-of HDMI-1
EOL

# Torna o script executável
sudo chmod +x /etc/X11/xinit/xinitrc.d/10-monitor_layout.sh

#################################################
### FIM DA CONFIGURAÇÃO DO ARANDR PARA O LXDM ###
#################################################

##########################################################################
## Instalação e configuração do scrot, utilitário para tirar screenchot ##
##########################################################################
# Instalacao do scrot
sudo pacman -S --noconfirm scrot

# Diretório para salvar capturas de tela
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Cria o diretório se ele não existir
mkdir -p "$SCREENSHOT_DIR"

# Criação do script para tirar screenshot
cat << 'EOF' > $HOME/bin/scrot_screenshot.sh
#!/bin/bash
# Script para tirar screenshot e salvar no diretório especificado
DATE=$(date +%Y-%m-%d_%H-%M-%S)
scrot "$HOME/Pictures/Screenshots/screenshot_$DATE.png"
EOF

# Torna o script executável
chmod +x $HOME/bin/scrot_screenshot.sh

# Adiciona atalho no Openbox (Assumindo que o usuário usa Openbox)
OPENBOX_CONFIG="$HOME/.config/openbox/rc.xml"

if ! grep -q "scrot_screenshot.sh" "$OPENBOX_CONFIG"; then
    sed -i '/<keyboard>/ a\
        <keybind key="Print">\
            <action name="Execute">\
                <command>$HOME/bin/scrot_screenshot.sh</command>\
            </action>\
        </keybind>' "$OPENBOX_CONFIG"
fi

# Recarregar a configuração do Openbox
openbox --reconfigure

#################################################################################
## Fim da instalação e configuração do scrot, utilitário para tirar screenchot ##
#################################################################################

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

# Caso queira instalar o Google Chrome normal do Google sem ajudante do AUR #
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si --noconfirm
cd ..
rm -rf google-chrome

# Reconfiguração automática do menu do Openbox usando Menumaker #
mmaker -vf openbox
# Lembrete: No AUR existe um pacote chamado "obmenu-generator" que você pode rodar no terminal "obmenu-generator -p -i" pra gerar um menu com icones.

# Finaliza a instalação e configuração
echo "Instalação e configuração inicial do Openbox concluídas. Reinicie o sistema para começar a usar."

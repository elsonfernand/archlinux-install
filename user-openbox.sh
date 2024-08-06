#!/bin/bash

# Cria diretórios necessários, se não existirem
[ ! -d ~/.config/openbox ] && mkdir -p ~/.config/openbox
[ ! -d ~/.config/tint2 ] && mkdir -p ~/.config/tint2
[ ! -d ~/.config/picom ] && mkdir -p ~/.config/picom

# Criar um arquivo de configuração básico do Picom
cat <<EOL > ~/.config/picom/picom.conf
# Shadows
shadow = true;
shadow-radius = 12;
shadow-offset-x = -12;
shadow-offset-y = -12;
shadow-opacity = 0.43;
shadow-exclude = [
  "name = 'Notification'",
  "class_g = 'Conky'",
  "class_g = 'URxvt' && _NET_WM_STATE@:32a",
  "_GTK_FRAME_EXTENTS@:c"
];

# Fading
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.05;
fade-delta = 4;

# Opacity
inactive-opacity = 1.0;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = true;

# Backend
backend = "glx";

# VSync
vsync = true;
EOL

# Criando arquivo de autostart do Openbox
cat <<EOL > ~/.config/openbox/autostart
## Iniciar ferramentas no login ##

#Barra de tarefas
tint2 &

# Controle de conexão com a intenet
nm-applet &

# Controle de energia
xfce4-power-manager &

# Controle e escolha de wallpaper
nitrogen --restore &

# Compositor
picom &

# Esquema de layout de monitor seguindo as configurações do ArandR
~/.config/openbox/dual-monitor.sh &

# Controle de volume de áudio
pasystray &

# Telegram (mensageiro)
telegram-desktop  -startintray &

# Polkit do LXDE
lxpolkit &

#Ativação do NumLock
numlockx &
EOL

# Criar arquivo de configuração do Tint2
cat <<EOL > ~/.config/tint2/tint2rc
# Configurações básicas do tint2
panel_monitor = primary
panel_position = bottom center horizontal
panel_size = 100% 43
panel_margin = 0 0
panel_padding = 7 0 7
panel_background_id = 1
wm_menu = 1
EOL

# Finalizar a configuração
echo "Configuração inicial do Openbox concluída."
echo "Leia a Wiki do Arch Linux sobre o Openbox, Tint2, Picom e altere ao seu gosto."

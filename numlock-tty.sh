#!/bin/bash

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

echo "Numlock configuration completed!"

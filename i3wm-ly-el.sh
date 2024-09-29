#!/bin/bash

# Verificação se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root."
  exit
fi

echo "Atualizando os pacotes..."
# Atualização do sistema
pacman -Syu --noconfirm

echo "Instalando i3wm, i3status, i3lock, i3blocks, dmenu e ly..."
# Instalando o i3wm, i3status, i3lock, i3blocks, dmenu e o display manager Ly
pacman -S i3-wm i3status i3lock i3blocks dmenu ly --noconfirm

# Verificação da pasta de configuração do i3 se já existe
I3_CONFIG_DIR="$HOME/.config/i3"
if [ ! -d "$I3_CONFIG_DIR" ]; then
  echo "Criando diretório de configuração do i3..."
  mkdir -p "$I3_CONFIG_DIR"
fi

# Criando o arquivo de configuração padrão do i3, se não existir
I3_CONFIG_FILE="$I3_CONFIG_DIR/config"
if [ ! -f "$I3_CONFIG_FILE" ]; then
  echo "Criando arquivo de configuração padrão do i3..."
  i3-config-wizard
else
  echo "Arquivo de configuração do i3 já existe. Nenhuma mudança necessária."
fi

# Configuracao do startx para iniciar o i3wm
XINITRC="$HOME/.xinitrc"
if ! grep -q "exec i3" "$XINITRC"; then
  echo "Configurando .xinitrc para iniciar o i3wm..."
  echo "exec i3" > "$XINITRC"
else
  echo ".xinitrc já configurado para iniciar o i3wm."
fi

echo "Habilitando o display manager Ly..."
# Habilitando e iniciando o Ly como Display Manager
systemctl enable ly.service
systemctl start ly.service

echo "Instalação e configuração do i3wm e Ly (Display Manager) concluída!"

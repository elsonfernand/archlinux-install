#!/bin/bash

# Atualiza o sistema e instala o pasystray.
echo "Atualizando o sistema e instalando o pasystray..."
sudo pacman -Syu --noconfirm pasystray

# Verifica se o diretorio de configuracao do Openbox existe, se nao, cria.
CONFIG_DIR="$HOME/.config/openbox"
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Criando diretório de configuração do Openbox em $CONFIG_DIR..."
    mkdir -p "$CONFIG_DIR"
fi

# Adiciona o pasystray ao autostart do Openbox
AUTOSTART_FILE="$CONFIG_DIR/autostart"
if ! grep -q "pasystray &" "$AUTOSTART_FILE"; then
    echo "Adicionando pasystray ao autostart do Openbox..."
    echo "pasystray &" >> "$AUTOSTART_FILE"
else
    echo "pasystray já está configurado para iniciar automaticamente."
fi

echo "Configuração concluída."

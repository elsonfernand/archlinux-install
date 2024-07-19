#!/bin/bash

# Atualizacao dos repositorios e instalacao do zram-generator
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm zram-generator

# Criar o diretório de configuração do zram-generator
sudo mkdir -p /etc/systemd/zram-generator.conf.d

# Criar o arquivo de configuração do zram-generator
cat << EOF | sudo tee /etc/systemd/zram-generator.conf.d/override.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF

# Reinicializacao do serviço systemd-modules-load para aplicar a nova configuracao
sudo systemctl daemon-reload
sudo systemctl restart systemd-modules-load

# Verificar se o zram está funcionando
echo "Configuração do Zram com compressão zstd concluída."
echo "Espero que tenha dado tudo certo!"
echo -e "Se quiser verificar use o comando \033[0;32mlsblk\033[0m no terminal."

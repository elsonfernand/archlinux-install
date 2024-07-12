#!/bin/bash

# Atualizar sistema
sudo pacman -Syu

# Instalar o zram-generator
sudo pacman -S zram-generator

# Criar diretório de configuração do zram-generator
sudo mkdir -p /etc/systemd/zram-generator.conf.d

# Criar arquivo de configuração do zram-generator para usar zstd
cat <<EOL | sudo tee /etc/systemd/zram-generator.conf.d/zram.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOL

# Habilitar e iniciar o serviço do zram-generator
sudo systemctl enable /usr/lib/systemd/system-generators/zram-generator
sudo systemctl start /usr/lib/systemd/system-generators/zram-generator

# Verificar se o zram está funcionando
echo "Configuração do Zram com compressão zstd concluída."
echo "Verifique o estado do Zram com o comando: lsblk -o NAME,TYPE,SIZE,MODEL,STATE"
echo "Espero que tenha dado tudo certo!"

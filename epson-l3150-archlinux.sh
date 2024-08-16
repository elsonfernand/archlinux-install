#!/bin/bash


#╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╭╮╱╱╭━━━╮╭╮╭━━━┳━━━╮
#┃╭━━╯╱╱╱╱╱╱╱╱╱╱╱╱┃┃╱╱┃╭━╮┣╯┃┃╭━━┫╭━╮┃
#┃╰━━┳━━┳━━┳━━┳━╮╱┃┃╱╱╰╯╭╯┣╮┃┃╰━━┫┃┃┃┃
#┃╭━━┫╭╮┃━━┫╭╮┃╭╮╮┃┃╱╭┳╮╰╮┃┃┃╰━━╮┃┃┃┃┃
#┃╰━━┫╰╯┣━━┃╰╯┃┃┃┃┃╰━╯┃╰━╯┣╯╰┳━━╯┃╰━╯┃
#╰━━━┫╭━┻━━┻━━┻╯╰╯╰━━━┻━━━┻━━┻━━━┻━━━╯
#╱╱╱╱┃┃
#╱╱╱╱╰╯

# Atualizar o sistema
sudo pacman -Syu --noconfirm

# █▀█ █▀▀ █▀█ █▀█ █▀ █ ▀█▀ █▀█ █▀█ █ █▀█   █▀█ █▀▀ █ █▀▀ █ ▄▀█ █░░
# █▀▄ ██▄ █▀▀ █▄█ ▄█ █ ░█░ █▄█ █▀▄ █ █▄█   █▄█ █▀░ █ █▄▄ █ █▀█ █▄▄

# Função para verificar se um pacote está instalado
function instalar_pacote {
    for pacote in "$@"; do
        if ! pacman -Qs $pacote > /dev/null ; then
            echo "Instalando $pacote..."
            sudo pacman -S --noconfirm $pacote
        else
            echo "$pacote já está instalado."
        fi
    done
}

# Instalar dependências para AUR
instalar_pacote git base-devel

# Instala alguns pacotes essenciais
instalar_pacote cups ghostscript gsfonts libcups gutenprint foomatic-db-gutenprint-ppds boost cmake rapidjson

# Verifica se alguns serviços essenciais para uso da impressora existem antes de habilitá-los
if systemctl list-unit-files | grep -q 'cups.service'; then
    echo "Ativando e iniciando "cups.service"..."
    sudo systemctl enable --now cups.service
fi

if systemctl list-unit-files | grep -q 'cups.socket'; then
    echo "Ativando e iniciando "cups.socket"..."
    sudo systemctl enable --now cups.socket
fi

if systemctl list-unit-files | grep -q 'cups.path'; then
    echo "Ativando e iniciando "cups.path"..."
    sudo systemctl enable --now cups.path
fi

# Baixa utilitário de configuração de impressora com GUI
instalar_pacote system-config-printer

# Cria o grupo 'lp' se não existir
echo "Verificando e criando grupo 'lp' se necessário..."
if ! grep -q '^lp:' /etc/group; then
    sudo groupadd lp
fi

# Adiciona usuário ao grupo lp
sudo usermod -aG lp $USER

# Suporte a digitalização sem driver
instalar_pacote sane-airscan sane ipp-usb

# Cria os grupos 'saned' e 'scanner' se não existirem
echo "Verificando e criando grupos 'saned' e 'scanner' se necessário..."
if ! grep -q '^saned:' /etc/group; then
    sudo groupadd saned
fi

if ! grep -q '^scanner:' /etc/group; then
    sudo groupadd scanner
fi

# Adicionar usuário aos grupos saned e scanner 
sudo usermod -aG saned,scanner $USER

# Verifica se o serviço para uso da impressora com USB existe antes de habilitá-lo
if systemctl list-unit-files | grep -q 'ipp-usb.service'; then
    echo "Ativando e iniciando serviços do PipeWire..."
    sudo systemctl enable --now ipp-usb.service
fi

# Utilitário para escanear documentos
instalar_pacote simple-scan


# ▄▀█ █░█ █▀█
# █▀█ █▄█ █▀▄

# Função para exibir mensagens
function msg() {
    echo -e "\e[1;32m$1\e[0m"
}

# Função para instalar um pacote do AUR
function instalar_pacote_aur() {
    local pacote=$1
    local url=$2

    if ! pacman -Qi "$pacote" &> /dev/null; then
        msg "Instalando $pacote..."
        if git clone "$url"; then
            cd "$pacote" || { echo "Falha ao entrar no diretório $pacote"; exit 1; }
            if yes | makepkg -si; then
                msg "$pacote instalado com sucesso."
            else
                echo "Falha ao compilar e instalar $pacote"
                exit 1
            fi
            cd .. || { echo "Falha ao voltar para o diretório anterior"; exit 1; }
            rm -rf "$pacote"
        else
            echo "Falha ao clonar o repositório $pacote"
            exit 1
        fi
    else
        msg "$pacote já está instalado."
    fi
}

# Baixar e instalar o driver Epson do AUR
instalar_pacote_aur "epson-inkjet-printer-escpr" "https://aur.archlinux.org/epson-inkjet-printer-escpr.git"

# Baixar e instalar o driver Epson do AUR
instalar_pacote_aur "epson-inkjet-printer-escpr2" "https://aur.archlinux.org/epson-inkjet-printer-escpr2.git"

# Baixar e instalar a descoberta de scanner através do iScan, o "Image Scan for Linux"
instalar_pacote_aur "iscan-plugin-network" "https://aur.archlinux.org/iscan-plugin-network.git"

# Baixar e instalar o utilitário Epson Connect do AUR para imprimir e-mails, documentos ou fotos a partir de qualquer dispositivo que possa enviar um e-mail
instalar_pacote_aur "epson-printer-utility" "https://aur.archlinux.org/epson-printer-utility.git"

# Baixar e instalar o suporte para aplicativos que podem ser iniciados apenas uma vez por usuário
instalar_pacote_aur "qt5-singleapplication" "https://aur.archlinux.org/qt5-singleapplication.git"

# Baixar e instalar o utilitário Imagescan Plugin Networkscan para utilização do scanner através da rede
instalar_pacote_aur "imagescan-plugin-networkscan" "https://aur.archlinux.org/imagescan-plugin-networkscan.git"

# Baixar e instalar o utilitário para usar scanner da Epson
instalar_pacote_aur "iscan" "https://aur.archlinux.org/iscan.git"

echo "Configuração concluída. Reinicie o sistema para garantir que todas as alterações tenham efeito. Caso dê algum erro no download/instalação, sugiro que instale um ajudante do AUR e instale os pacotes separadamente."

#!/bin/bash

# Atualizar o sistema
sudo pacman -Syu --noconfirm

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

# Baixar e instalar o utilitário de funções básicas e avançadas de digitalização
if ! command -v epsonscan2 &> /dev/null; then
    echo "Instalando epsonscan2..."
    git clone https://aur.archlinux.org/epsonscan2.git
    cd epsonscan2
    yes | makepkg -si
    cd ..
    rm -rf epsonscan2
else
    echo "epsonscan2 já está instalado."
fi

# Baixar e instalar o driver Epson do AUR
if ! command -v epson-inkjet-printer-escpr &> /dev/null; then
    echo "Instalando epson-inkjet-printer-escpr..."
    git clone https://aur.archlinux.org/epson-inkjet-printer-escpr.git
    cd epson-inkjet-printer-escpr
    yes | makepkg -si
    cd ..
    rm -rf epson-inkjet-printer-escpr
else
    echo "epson-inkjet-printer-escpr já está instalado."
fi

# Baixar e instalar o driver Epson do AUR
if ! command -v epson-inkjet-printer-escpr2 &> /dev/null; then
    echo "Instalando epson-inkjet-printer-escpr2..."
    git clone https://aur.archlinux.org/epson-inkjet-printer-escpr2.git
    cd epson-inkjet-printer-escpr2
    yes | makepkg -si
    cd ..
    rm -rf epson-inkjet-printer-escpr2
else
    echo "epson-inkjet-printer-escpr2 já está instalado."
fi

# Baixar e instalar a descoberta de scanner através do iScan, o "Image Scan for Linux"
if ! command -v iscan-plugin-network &> /dev/null; then
    echo "Instalando iscan-plugin-network..."
    git clone https://aur.archlinux.org/iscan-plugin-network.git
    cd iscan-plugin-network
    yes | makepkg -si
    cd ..
    rm -rf iscan-plugin-network
else
    echo "iscan-plugin-network já está instalado."
fi

# Baixar e instalar o utilitário Epson Connect do AUR para imprimir e-mails, documentos ou fotos a partir de qualquer dispositivo que possa enviar um e-mail
if ! command -v epson-printer-utility &> /dev/null; then
    echo "Instalando epson-printer-utility..."
    git clone https://aur.archlinux.org/epson-printer-utility.git
    cd epson-printer-utility
    yes | makepkg -si
    cd ..
    rm -rf epson-printer-utility
else
    echo "epson-printer-utility já está instalado."
fi

# Baixar e instalar o suporte para aplicativos que podem ser iniciados apenas uma vez por usuário
if ! command -v qt5-singleapplication &> /dev/null; then
    echo "Instalando qt5-singleapplication..."
    git clone https://aur.archlinux.org/qt5-singleapplication.git
    cd qt5-singleapplication
    yes | makepkg -si
    cd ..
    rm -rf qt5-singleapplication
else
    echo "qt5-singleapplication já está instalado."
fi

# Baixar e instalar o utilitário Imagescan Plugin Networkscan para utilização do scanner através da rede
if ! command -v imagescan-plugin-networkscan &> /dev/null; then
    echo "Instalando imagescan-plugin-networkscan..."
    git clone https://aur.archlinux.org/imagescan-plugin-networkscan.git
    cd imagescan-plugin-networkscan
    yes | makepkg -si
    cd ..
    rm -rf imagescan-plugin-networkscan
else
    echo "imagescan-plugin-networkscan já está instalado."
fi

# Baixar e instalar o utilitário para usar scanner da Epson
if ! command -v iscan &> /dev/null; then
    echo "Instalando iscan..."
    git clone https://aur.archlinux.org/iscan.git
    cd iscan
    yes | makepkg -si
    cd ..
    rm -rf iscan
else
    echo "iscan já está instalado."
fi

echo "Configuração concluída. Reinicie o sistema para garantir que todas as alterações tenham efeito."

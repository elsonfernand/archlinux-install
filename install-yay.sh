#!/bin/bash

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

# Se certificando que tem o "git", "go" e "base-devel" estao instalados
instalar_pacote git go base-devel
# Baixando o código fonte:
git clone https://aur.archlinux.org/yay.git
# Acessando a pasta:
cd yay
# Compilando:
yes | makepkg -si
# Indo para a home
cd
# Limpando resíduos de download feito
rm -rf yay

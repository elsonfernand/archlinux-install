#!/bin/bash

# Define o diretório e o nome base para as capturas de tela
DIR=~/Pictures/Screenshots
BASE_NAME="Screenshot-$(date +'%Y-%m-%d')"

# Cria o diretório se não existir
mkdir -p "$DIR"

# Incrementa o nome do arquivo se ele já existir
FILE_NAME="$BASE_NAME.png"
COUNT=1
while [ -e "$DIR/$FILE_NAME" ]; do
    FILE_NAME="${BASE_NAME}_#$(printf "%03d" $COUNT).png"
    COUNT=$((COUNT + 1))
done

# Executa o comando scrot
scrot "$DIR/$FILE_NAME"

#╭━╮╭━╮╱╱╱╱╱╱╱╱╭╮
#┃┃╰╯┃┃╱╱╱╱╱╱╱╭╯╰╮
#┃╭╮╭╮┣━━┳━╮╭╮┣╮╭╋━━┳━╮╭━━┳━━┳━━╮
#┃┃┃┃┃┃╭╮┃╭╮┫┃┃┃┃┃┃━┫╭╮┫╭━┫╭╮┃╭╮┃
#┃┃┃┃┃┃╭╮┃┃┃┃╰╯┃╰┫┃━┫┃┃┃╰━┫╭╮┃╰╯┃
#╰╯╰╯╰┻╯╰┻╯╰┻━━┻━┻━━┻╯╰┻━━┻╯╰┻━━╯

# Script que ajuda a manter a boa saúde do sistema
# Cheque os serviços do sistema que falharam
systemctl --failed

# Cheque os arquivos de log
sudo journalctl -p 3 -xb

# Atualize
sudo pacman -Syu

# Atualize o Yay (se você estiver usando o Paru utilize-o)
yay

# Delete o cache do Pacman
sudo pacman -Scc

# Delete o cache do Yay (se você estiver usando o Paru utilize-o)
yay -Scc

# Delete dependências indesejadas (se você estiver usando o Paru utilize-o)
yay -Yc

# Cheque pacotes que ficaram órfãos 
pacman -Qtdq

# Remova esses pacotes orfãos
sudo pacman -Rns $(pacman -Qtdq)

# Limpe a pasta de Cache
rm -rf .cache/*

# Limpe o Journal
sudo journalctl --vacuum-time=2weeks

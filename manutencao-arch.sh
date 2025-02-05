#╭━╮╭━╮╱╱╱╱╱╱╱╱╭╮
#┃┃╰╯┃┃╱╱╱╱╱╱╱╭╯╰╮
#┃╭╮╭╮┣━━┳━╮╭╮┣╮╭╋━━┳━╮╭━━┳━━┳━━╮
#┃┃┃┃┃┃╭╮┃╭╮┫┃┃┃┃┃┃━┫╭╮┫╭━┫╭╮┃╭╮┃
#┃┃┃┃┃┃╭╮┃┃┃┃╰╯┃╰┫┃━┫┃┃┃╰━┫╭╮┃╰╯┃
#╰╯╰╯╰┻╯╰┻╯╰┻━━┻━┻━━┻╯╰┻━━┻╯╰┻━━╯

# Para automatizar esse script sem a necessidade de confirmação do usuário adicione a partir da atualização do Yay "yes | " antes do comando. Por exemplo: "yes | yay". Os dois últimos itens não tem necessidade desse acréscimo.

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

# Dica: se quiser automatizar esse processo você também pode adicionar um "alias" no seu  seu arquivo _.bashrc_, por exemplo, adicionando o seguinte:
#alias upsysfull='yes| sudo pacman -Syu; yes | yay ; yes | sudo pacman -Scc ; yes| yay -Scc ; sudo pacman -Rns $(pacman -Qdtq) ; yes | rm -rf .cache/*'
#Agora, no seu terminal, é só digitar "upsysfull", sem as aspas, que esse processo vai ser feito automaticamente.

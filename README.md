<p align="center">
  <img height="100" src="https://archlinux.org/static/logos/archlinux-logo-dark-scalable.518881f04ca9.svg" alt="Arch Linux logo svg" >
</p>

# Scripts simples em shell
   
> Scripts simples em shell para otimização de tempo, que leva a vida de um burro, em instalações básicas do Arch Linux.

## Pré-requisitos

#### Antes de começar, verifique se você atendeu aos seguintes requisitos:
- Você instalou a versão mais recente de `<paciência / vista grossa para código n00b / autocontrole>`
- Você tem na sua máquina `<PC ou notebook dando boot / Secure Boot desativado>`.
- Pendrive bootável com ISO mais atual do Arch Linux. Você pode fazer o download <a href="https://archlinux.org/download/" target="blank">aqui</a>.
- Você leu <a href="https://wiki.archlinux.org/title/Installation_guide" target="blank">a wiki do projeto</a>.

*Esse repositório está em constante desenvolvimento e aqui você encontrará scripts para a instalação base do Arch Linux e ambientes de desktop (por enquanto apenas o *KDE Plasma 6* e *Openbox*, esse último é o que uso no momento e o KDE Plasma usei por quase dois anos). Edite baseado na sua necessidade, dê permissão de escrita com ***chmod +x "nome-do-script".sh*** e então execute com ***./"nome-do-script".sh***. Lembre-se que a primeira parte da instalação do Arch Linux é manual, ou seja, você terá que particionar, formatar e montar o disco você mesmo. Instale os pacotes base e certifique-se de incluir o **git** para que você possa clonar o repositório no *chroot*.*

### Um pequeno resumo da instalação do Arch Linux que eu sigo:

01. Carregue seu mapa de teclado (nesse caso, o layout padrão do Brasil):
```
loadkeys br-abnt2
```
02. Teste sua conexão com a internet:
```
ping -c7 archlinux.org
```
03. Conheça os seus discos:
```
lsblk
```
04. Particione o disco como bem entender.
   - Aqui estarei usando:
```
cfdisk
```
> [!NOTE]
> Utilizo UEFI, então, particiono 100MB (*/dev/sda1* = partição EFI Filesystem), dependendo do tamanho do disco 60GB ou 30GB (*/dev/sda2* = partição Raíz ou "/") e o restante (*/dev/sda3* = partição de arquivos do usuário ou "/home"). No total, 3 partições. Não utilizo *swap* porque prefiro utilizar <a href="https://wiki.archlinux.org/title/Zram" target="blank">zram</a>.
05. Verifique se o particionamento deu certo com:
```
lsblk
```
#### Ficará assim:
```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 335.4G  0 disk 
├─sda1   8:1    0   285M  0 part 
├─sda2   8:2    0  55.9G  0 part 
└─sda3   8:3    0 279.2G  0 part 
```
06. Formate a partição boot/efi:
```
mkfs.fat -F32 /dev/sda1
```
07. Aqui irei usar o sistema *BTRFS* na raiz:
> [!NOTE]
> Na Home, se ela já tiver sido particionada e cheia de arquivos, você pode pular essa parte e continuar com seus arquivos com o sistema de arquivos que já estiver nela (seja *ext4*, *ext3*, *ZFS*, ou o que for). Caso deseje mudar o sistema de arquivos, aproveitando que estará instalando um sistema base, salve antes tudo o que for importante numa nuvem ou pendrive ou HD externo e meta bala nessa instalação!!
```
mkfs.btrfs /dev/sda2
```
```
mkfs.btrfs /dev/sda3
```
> [!TIP]
> Se essa parte der errado tente primeiro desmontar o que estiver montado com ***umount -a*** e tente novamente. Se ainda deu errado acrescente ***-f*** antes do */dev*, ficando: ***mkfs.btrfs -f /dev/sda2***.
08. Agora devemos montar a nossa partição raiz em */mnt*:
```
mount /dev/sda2 /mnt
```
09. Agora vamos montar a partição de boot em um diretório que ainda não existe. Sendo assim deve-se usar:
```
mkdir -p /mnt/boot/efi
```
10. Monte a partição de boot/efi nesse diretório que acabou de ser criado:
```
mount /dev/sda1 /mnt/boot/efi
```
> [!TIP]
> Se estiver fazendo esse processo com a **/home** separada crie um diretório com ***mkdir -p /mnt/home*** e monte com ***mount /dev/sda3 /mnt/home***, nessa ordem, deixando a */home* por último.

#### Com as partições montadas (use *lsblk* para verificar). Ficará assim:
```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 335.4G  0 disk 
├─sda1   8:1    0   285M  0 part /boot/efi
├─sda2   8:2    0  55.9G  0 part /
└─sda3   8:3    0 279.2G  0 part /home
```

11. Instale os pacotes base com o pacstrap:
```
pacstrap -K /mnt base linux linux-firmware base-devel intel-ucode grub dosfstools btrfs-progs efibootmgr git nano networkmanager
```
> [!NOTE]
> *base-devel* será instalado aqui de início para que os pacotes do AUR, com algum ajudante (paru ou yay), seja instalado lá na frente; *intel-ucode*, para processadores intel mas se estiver usando AMD utilize *amd-ucode*; *grub* e *efibootmgr* serão instalados também para dar suporte na inicialização do sistema; o *grub-btrfs* é necessário para uso do BTRFS; o *nano* será instalado para termos um editor de texto simples de terminal e finalmente o *networkmanager* será instalado para termos acesso a internet.
12. Vamos agora gerar o *FSTAB* que é o arquivo localizado em ***/etc/fstab*** responsável por armazenar a configuração de quais dispositivos devem ser montados e qual o ponto de montagem de cada um na carga do sistema operacional, mesmo dispositivos locais e remotos. 
    - Para gerar digite:
```
genfstab  /mnt >> /mnt/etc/fstab
```
13. Se a essa altura nada deu errado até agora vamos entrar no sistema instalado para configurar o sistema base por dentro.
    - Para isso digite:
```
arch-chroot /mnt
```
> [!NOTE]
> A partir de agora você já se encontra dentro da instalação. Uma coisa que eu faço nessa parte, antes de tudo, é alterar alguns parâmetros do arquivo do **pacman**. Utilizo o comando ***nano /etc/pacman.conf***, descomento a opção *Color* dentro de *# Misc Options*, descomento o *ParallelDownloads* e coloco ***16*** ao invés de 5, adiciono nessa sessão, na última linha, ***ILoveCandy*** que é o efeito do Pacman comendo as frutinhas na barra de progresso quando o gerenciador de pacotes Pacman é executado e descomento as duas linhas do *multilib*, salvo com *CTRL + S* e fecho o ***nano*** com *CTRL + X*. Agora dou um **pacman -Sy** pra ele atualizar as bibliotecas e continuo o processo.
14. Agora é a hora de pegar o script com:
```
git clone https://github.com/elsonfernand/archlinux-install.git
```
15. Entre no diretório do script:
```
cd /archlinux-install/
```
16. Altere, se você achar necessáro, o conteúdo do script:
```
nano <nome-do-script>.sh
```
17. Dê permissão de escrita:
```
chmod +x <nome-do-script>.sh
```
18. Execute com:
```
./<nome-do-script>.sh
```
> [!IMPORTANT]
> Use ***cp -r /archlinux-install .*** antes de sair do *arch-chroot* (com o *exit*), desmontar as partições com *umount -a*, desligar o sistema com o *poweroff* para que continue a instalação de um Ambiente de Trabalho e ou Window Manager de sua preferência. Esse comando copia a pasta com esses scripts e você pode continuar depois de reiniciar o sistema sem se preocupar com clonar esse repositório novamente.

> [!TIP]
> Se você escolher usar o Openbox, <a href="https://github.com/addy-dclxvi/openbox-theme-collections" target="blank">nesse repositório</a> tem muitas opções legais de tema. Eu mesmo utilizo o tema Arc-Dark em qualquer ambiente de trabalho que escolho.

## Licença

Pode passar.

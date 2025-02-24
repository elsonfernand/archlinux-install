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

⇢ Esse repositório está em constante desenvolvimento e aqui você encontrará scripts para a instalação base do Arch Linux e ambientes de desktop (por enquanto o **KDE Plasma 6**, **Openbox** e o **i3wm** esse último é o que uso no momento);

⇢ Edite baseado na sua necessidade, dê permissão de escrita com ***chmod +x "nome-do-script".sh*** e então execute com ***./"nome-do-script".sh***;

⇢ Lembre-se que a primeira parte da instalação do Arch Linux é manual, ou seja, você terá que particionar, formatar e montar o disco você mesmo;

⇢ Instale os pacotes base e certifique-se de incluir o **git** para que você possa clonar o repositório no *chroot*;

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
> Utilizo UEFI, então, particiono 100MB (*/dev/sda1* = partição EFI Filesystem), dependendo do tamanho do disco 60GB ou 30GB (*/dev/sda2* = partição Raiz ou "/") e o restante (*/dev/sda3* = partição de arquivos do usuário ou "/home"). No total, 3 partições. Não utilizo *swap* porque prefiro utilizar <a href="https://wiki.archlinux.org/title/Zram" target="blank">zram</a>.

> [!NOTE]
> Tive um problema utilizando esse gerenciador de particionamento quando fiz uma instalação em um *nvme* e tive que usar o comando ***cfdisk /dev/nvme0n1*** pra ele entender qual era o disco que eu queria formatar e particionar.
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
Ou assim caso você esteja usando um *SSD nvme*:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 232.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part
├─nvme0n1p2 259:2    0    80G  0 part
└─nvme0n1p3 259:3    0 152.4G  0 part
```
06. Formate a partição boot/efi:
```
mkfs.fat -F32 /dev/sda1
```
Ou:
```
mkfs.fat -F32 /dev/nvme0n1p1
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
Ou:
```
mkfs.btrfs /dev/nvme0n1p2
```
```
mkfs.btrfs /dev/nvme0n1p3
```
> [!TIP]
> Se essa parte der errado tente primeiro desmontar o que estiver montado com ***umount -a*** e tente novamente. Se ainda deu errado acrescente ***-f*** antes do */dev*, ficando: ***mkfs.btrfs -f /dev/sda2*** (ou ***mkfs.btrfs -f /dev/nvme0n1p2***).
08. Agora devemos montar a nossa partição raiz em */mnt*:
```
mount /dev/sda2 /mnt
```
Ou:
```
mount /dev/nvme0n1p2 /mnt
```
09. Agora vamos montar a partição de boot em um diretório que ainda não existe. Sendo assim deve-se usar:
```
mkdir -p /mnt/boot/efi
```
10. Monte a partição de boot/efi nesse diretório que acabou de ser criado:
```
mount /dev/sda1 /mnt/boot/efi
```
Ou:
```
mount /dev/nvme0n1p1 /mnt/boot/efi
```
> [!TIP]
> Se estiver fazendo esse processo com a **/home** separada crie um diretório com ***mkdir -p /mnt/home*** e monte com ***mount /dev/sda3 /mnt/home*** (ou ***mount /dev/nvme0n1p3 /mnt/home***), nessa ordem, deixando a */home* por último.
#### Com as partições montadas (use *lsblk* para verificar). Ficará assim:
```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 335.4G  0 disk 
├─sda1   8:1    0   285M  0 part /mnt/boot/efi
├─sda2   8:2    0  55.9G  0 part /mnt
└─sda3   8:3    0 279.2G  0 part /mnt/home
```
Ou:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 232.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0    80G  0 part /
└─nvme0n1p3 259:3    0 152.4G  0 part /home
```
11. Instale os pacotes base com o pacstrap:
```
pacstrap -K /mnt base linux linux-firmware base-devel intel-ucode grub dosfstools btrfs-progs efibootmgr git nano networkmanager
```
> [!NOTE]
> *base-devel* será instalado aqui de início para que os pacotes do AUR, com algum ajudante (paru ou yay), seja instalado lá na frente; *intel-ucode*, para processadores intel mas se estiver usando AMD utilize *amd-ucode*; *grub* e *efibootmgr* serão instalados também para dar suporte na inicialização do sistema; o *dosftools* são um conjunto de programas para criar, verificar e rotular sistemas de arquivos da família FAT; o *grub-btrfs* é necessário para uso do BTRFS; o *nano* será instalado para termos um editor de texto simples de terminal e finalmente o *networkmanager* será instalado para termos acesso a internet.
12. Vamos agora gerar o *FSTAB* que é o arquivo localizado em ***/etc/fstab*** responsável por armazenar a configuração de quais dispositivos devem ser montados e qual o ponto de montagem de cada um na carga do sistema operacional, mesmo dispositivos locais e remotos. 
    - Para gerar digite:
```
genfstab -U /mnt >> /mnt/etc/fstab
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
> [!TIP]
> **Dica 1**: Se usar o editor *nano* navegue pelas palavras com as setas do teclado. Para salvar as alterações é só pressionar *CTRL + S* e para fechar esse editor é só pressionar *CTRL + X* ou se quiser "Salvar como..." é só pressionar *CTRL + O* e confirmar que gostaria de salvar por cima do mesmo arquivo. **Dica 2**: Se não quiser instalar algo é só comentar a linha (você faz isso colocando # antes da primeira palavra dessa linha e salvar o arquivo) ou apague-a.

17. Dê permissão de escrita:
```
chmod +x <nome-do-script>.sh
```
18. Execute com:
```
./<nome-do-script>.sh
```
> [!IMPORTANT]
> Use ***cp -r /archlinux-install /mnt/home*** antes de sair do *arch-chroot* (com o *exit*), desmonte as partições com *umount -a*, desligue o sistema com o *poweroff* para que continue a instalação de um Ambiente de Trabalho e ou Window Manager de sua preferência. Esse comando copia a pasta com esses scripts e você pode continuar depois de reiniciar o sistema sem se preocupar com clonar esse repositório novamente.

> [!TIP]
> Se você escolher usar o Openbox, <a href="https://github.com/addy-dclxvi/openbox-theme-collections" target="blank">nesse repositório</a> tem muitas opções legais de tema. Eu mesmo utilizo o tema Arc-Dark na maioria dos ambientes de trabalho que escolho.

⇢ Pronto! É assim que eu faço a minha instalação do Arch Linux. Agora você também pode dizer a todo mundo que não precisa do *Archinstall* e pode dizer com propriedade *I use Arch BTW* em todos os fóruns que encontrar, na sua roda de amigos (reais, virtuais e imaginários), nas reuniões de família, no seu trabalho, na sua *call* e no seu mensageiro favorito.

## Licença

Pode passar.

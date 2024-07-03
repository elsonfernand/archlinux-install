# Scripts simples em shell

<img align="center" src="https://archlinux.org/static/logos/archlinux-logo-dark-scalable.518881f04ca9.svg" alt="Arch Linux logo svg" height="100">

> Scripts simples em shell para otimização de tempo em instalações básicas do Arch Linux.

## Pré-requisitos

Antes de começar, verifique se você atendeu aos seguintes requisitos:

- Você instalou a versão mais recente de `<paciência / vista grossa para código n00b / autocontrole>`
- Você tem na sua máquina `<uma batata / conhecimento para fazer um pendrive bootável / Linux>`.
- Você leu <a href="https://wiki.archlinux.org/title/Installation_guide" target="blank">a wiki do projeto</a>.

Esse repositório está em constante desenvolvimento e aqui você encontrará scripts para a instalação base do Arch Linux e ambientes de desktop (por enquanto apenas o KDE Plasma 6, pois é o único que uso no momento). Edite baseado na sua necessidade, dê permissão de escrita com ***chmod +x <nome-do-script>*** e então execute com ***./<nome-do-script>***. Lembre-se que a primeira parte da instalação do Arch Linux é manual, ou seja, você terá que particionar, formatar e montar o disco você mesmo. Instale os pacotes base e certifique-se de incluir o git para que você possa clonar o repositório no chroot.

#### Um pequeno resumo da instalação do Arch Linux para que você possa utilizar os scripts desse repositório:

Carregue seu mapa de teclado (nesse caso, o layout padrão do Brasil):

```
loadkeys br-abnt2
```

Teste sua conexão com a internet:

```
ping -c7 archlinux.org
```

Conheça os seus discos:

```
lsblk
```

Particione o disco como bem entender.

Aqui estarei usando:

```
cfdisk
```
> [!NOTE]
> Utilizo UEFI, então, particiono 100MB, (dependendo do disco) 60GB e o resto. No total, 3 partições. 


Formate a partição boot/efi:

```
mkfs.fat -F32 /dev/sda1
```
Aqui irei usar o sistema *BTRFS* na raiz (e na Home se ela tiver sido particionada):

```
mkfs.btrfs /dev/sda2
```
```
mkfs.btrfs /dev/sda3
```
> [!TIP]
> Se essa parte der errado tente primeiro desmontar o que estiver montado com ***umount -a*** e tente novamente. Se ainda deu errado acrescente ***-f*** antes do */dev*, ficando: ***mkfs.btrfs /dev/sda2***.

Agora devemos montar a nossa partição raiz em */mnt*:

```
mount /dev/sda2 /mnt
```

Agora vamos montar a partição de boot em um local que ainda não existe. Sendo assim deve-se usar:
```
mkdir -p /mnt/boot/efi
```

Monte a partição de boot/efi nesse diretório que acabou de ser criado:
```
mount /dev/sda1 /mnt/boot/efi
```

> [!TIP]
> Se estiver fazendo esse processo com a **/home** separada crie um diretório com ***mkdir -p /mnt/home*** e monte com ***mount /dev/sda3 /mnt/home***, nessa ordem.

Instale os pacotes base com o pacstrap:
```
pacstrap -K /mnt base linux linux-firmware base-devel intel-ucode grub btrfs-progs efibootmgr git nano networkmanager
```
> [!NOTE]
> *base-devel* será instalado aqui de início para que os pacotes do AUR, com algum ajudante (paru ou yay), seja instalado lá na frente; *intel-ucode*, para processadores intel mas se estiver usando AMD utilize *amd-ucode*; *grub* e *efibootmgr* serão instalados também para dar suporte na inicialização do sistema; o *grub-btrfs* é necessário para uso do BTRFS; o *nano* será instalado para termos um editor de texto simples de terminal e finalmente o *networkmanager* será instalado para termos acesso a internet.

Vamos agora gerar o *FSTAB* que é o arquivo localizado em ***/etc/fstab*** responsável por armazenar a configuração de quais dispositivos devem ser montados e qual o ponto de montagem de cada um na carga do sistema operacional, mesmo dispositivos locais e remotos. Para gerar digite:
```
genfstab  /mnt >> /mnt/etc/fstab
```
Se a essa altura nada deu errado até agora vamos entrar no sistema instalado para configurar o sistema base por dentro.

Para isso digite:
```
arch-chroot /mnt
```
Agora é a hora de pegar o script com:
```
git clone https://github.com/elsonfernand/archlinux-public.git
```
Entre no diretório do script:
```
cd /archlinux-public/
```
Altere, se você achar necessáro, o conteúdo do script:
```
nano <nome-do-script>.sh
```
Dê permissão de escrita:
```
chmod +x <nome-do-script>.sh
```
Execute com:
```
./<nome-do-script>.sh
```
> [!IMPORTANT]
> Fique de olho no que esse script está fazendo pois possa ser que ele faça explodir seu domicílio inteiro.

## Licença

Esse projeto não está sob licença. Modifique, refaça, me mande uma DM pra me xingar.

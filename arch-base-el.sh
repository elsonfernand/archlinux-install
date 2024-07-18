#!/bin/bash

# Configuracao do fuso horario com:
ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
# Nota: como voce se encontra no Nordeste do Brasil, esse eh o comando correto para o seu caso. kkkkk
# Sincronizacao do relogio:
hwclock --systohc

# Aqui vai ser definido o idioma do sistema instalado. Caso queira portugues do Brasil altere para "LANG=pt_BR.UTF-8"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Layout do teclado
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf

# Nome do computador
echo "archlinux" >> /etc/hostname

# Troque o nome 'password' por uma senha de sua preferencia.
echo root:password | chpasswd

# Alguns pacotes sugeridos.
# pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet fastfetch dialog wpa_supplicant mtools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion rsync reflector acpi acpi_call tlp edk2-ovmf bridge-utils dnsmasq vde2 ipset firewalld sof-firmware nss-mdns acpid ntfs-3g

# Pacote do Pacman que contem alguns scripts
sudo pacman -S --noconfirm pacman-contrib

# Descomente a opcao abaixo se você esta usando o VirtualBox.
pacman -S --noconfirm virtualbox-guest-utils
# Descomente a opcao abaixo se você usa placa de vídeo da AMD.
# pacman -S --noconfirm xf86-video-amdgpu
# Opção descomentada porque uso nvidia, se não for o seu caso, comente.
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Instalando e gerando o GRUB
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Ativando Internet, criando arquivo de configuracao do Fastfetch, bluetooth, impressora, script de espelhos mais proximo, firewall e permicoes de convidado se usando VirtualBox. Descomente apenas o necessario, caso contrario nao ira funcionar.
# Internet
systemctl enable NetworkManager
# Arquivo do Fastfetch se encontra em ~/.config/fastfetch/config.jsonc e voce pode alterar ele com o nano ou editor de texto de sua preferencia
#fastfetch --gen-config
# Bluetooth
#systemctl enable bluetooth
# Impressora
#systemctl enable cups.service
# Permicao para que programas publiquem e descubram os servicos e as maquinas que funcionam em uma rede local sem nenhuma configuração especifica
#systemctl enable avahi-daemon
# Script que pode recuperar a lista de espelhos mais recente da pagina MirrorStatus, filtrar os espelhos mais atualizados, classifica-los por velocidade e substituir o arquivo /etc/pacman.d/mirrorlist
#systemctl enable reflector.timer
# Seguranca da rede que monitora o trafego de rede de entrada e saida e decide permitir ou bloquear trafegos especificos de acordo com um conjunto definido de regras de segurança
#systemctl enable firewalld
# Servico do Virtualbox
#systemctl enable vboxservice.service

# Atualizando a lista de espelhos para melhor download dos pacotes de atualizacao e novas instalacoes. So descomente se voce ja fez a instalação nos passos anteriores.
# pacman -S --noconfirm reflector ; sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Adicionando e criando um usuario no grupo "wheel". Troque o "el" pelo nome do seu usuario.
useradd -mG wheel -s /bin/bash el
# Crie senha para esse usuário. Altere 'password' para a sua senha.
echo el:password | chpasswd

# Adicionando privilegios de superusuario, lembre-se de trocar o "el" pelo nome de usuario que voce colocou la atras.
echo "el ALL=(ALL) ALL" >> /etc/sudoers.d/el

# LEMRETES
# Lembre-se de alterar o arquivo /etc/pacman.conf, aumente o numero de downloads para 10, descomente a opcao de multilib, descomente a opcao de Color, salve e fecheo editor. Agora atualize com "pacman -Sy" e continue.
# Para copiar os arquivos baixados do GitHub voce deve usar o comando "cp -r /archlinux-install ." depois desse processo de instalação da base e continuar a instalacao da interface grafica.
# Caso queira adicionar algumas opções no /etc/fstab eu recomendo essas aqui: noatime,space_cache=v2,compress=zstd,ssd,discard=async

printf "\033[0mPronto! Agora digite \033[01;37mexit\033[0m para sair desse modo, depois \033[01;37mumount -a\033[0m para desmontar as partições e desligue o sistema com \033[01;37mpoweroff\033[0m. Retire a mídia de instalação e inicie o sistema."

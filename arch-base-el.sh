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

# Descomente a opcao abaixo se você usa placa de vídeo da ADM.
# pacman -S --noconfirm xf86-video-amdgpu
# Opção descomentada porque uso nvidia, se não for o seu caso, comente.
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Instalando e gerando o GRUB
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Ativando Internet, bluetooth, impressora, script de espelhos mais proximo e firewall. Descomente apenas o necessario, caso contrario nao ira funcionar.
systemctl enable NetworkManager
#systemctl enable bluetooth
#systemctl enable cups.service
#systemctl enable avahi-daemon
#systemctl enable reflector.timer
#systemctl enable firewalld

# Atualizando a lista de espelhos para melhor download dos pacotes de atualizacao e novas instalacoes. So descomente se voce ja fez a instalação nos passos anteriores.
# pacman -S --noconfirm reflector ; sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Adicionando e criando um usuario no grupo "wheel". Troque o "el" pelo nome do seu usuario.
useradd -mG wheel -s /bin/bash el
# Crie senha para esse usuário. Altere 'password' para a sua senha.
echo el:password | chpasswd

# Adicionando privilegios de superusuario, lembre-se de trocar o "el" pelo nome de usuario que voce colocou la atras.
echo "el ALL=(ALL) ALL" >> /etc/sudoers.d/el

printf "\033[00;37mPronto! Agora digite \033[01;37mexit\033[00;37m para sair desse modo, depois \033[01;37mumount -a\033[00;37m para desmontar as partições e desligue o sistema com \033[01;37mpoweroff\033[00;37m. Retire a mídia de instalação e inicie o sistema."

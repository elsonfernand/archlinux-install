#!/bin/bash

# Configuração do fuso horário com:
ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
# Nota: como você se encontra no Nordeste do Brasil, esse é o comando correto para o seu caso. kkkkk
# Sincronização do relógio:
hwclock --systohc

# Aqui vai ser definido o idioma do sistema instalado. Caso queira português do Brasil altere para "LANG=pt_BR.UTF-8"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Layout do teclado
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf

# Nome do computador
echo "archlinux" >> /etc/hostname

# Troque o nome 'password' por uma senha de sua preferência.
echo root:password | chpasswd

# Alguns pacotes sugeridos.
# pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet fastfetch dialog wpa_supplicant mtools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion rsync reflector acpi acpi_call tlp edk2-ovmf bridge-utils dnsmasq vde2 ipset firewalld sof-firmware nss-mdns acpid ntfs-3g

# Descomente a opção abaixo se você usa placa de vídeo da ADM.
# pacman -S --noconfirm xf86-video-amdgpu
# Descomente a opção abaixo se você usa placa de vídeo da Nvidia.
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Instalando e gerando o GRUB
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Ativando Internet, bluetooth, impressora, script de espelhos mais proximo e firewall. Descomente apenas o necessário, caso contrário não irá funcionar.
systemctl enable NetworkManager
#systemctl enable bluetooth
#systemctl enable cups.service
#systemctl enable avahi-daemon
#systemctl enable reflector.timer
#systemctl enable firewalld

# Atualizando a lista de espelhos para melhor download dos pacotes de atualização e novas instalações. Só descomente se você já fez a instalação nos passos anteriores.
#sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup ; reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Adicionando e criando um usuário no grupo "wheel".
useradd -mG wheel -s /bin/bash el
# Crie senha para esse usuário. Altere 'password' para a sua senha.
echo el:password | chpasswd

# Adicionando privilégios de superusuário
echo "el ALL=(ALL) ALL" >> /etc/sudoers.d/el

printf "\e[1;32mPronto! Agora digite, exit, depois umount -a e desligue o sistema com poweroff. Religue em seguida.\e[0m"

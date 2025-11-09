#!/usr/bin/env bash
# --------------------------------------------------------------
# Recuperação automatizada do GRUB no Arch Linux (por Elson)
# --------------------------------------------------------------

set -e  # Interrompe o script se ocorrer algum erro

echo "==== Recuperação do GRUB no Arch Linux ===="
echo "Para facilitar a digitação, caso o teclado esteja errado:"
echo "Digite manualmente: loadkeys br-abnt2"
echo "----------------------------------------------------------"
echo ""

# === Solicita informações do usuário ===
read -rp "Informe a partição do sistema (ex: /dev/nvme0n1p2): " ROOT_PART
read -rp "Informe a partição EFI (ex: /dev/nvme0n1p1): " EFI_PART
read -rp "Informe a partição /home (ou deixe em branco se não houver): " HOME_PART

echo ""
echo "Montando partições..."
mount "$ROOT_PART" /mnt

mkdir -p /mnt/boot/efi
mount "$EFI_PART" /mnt/boot/efi

if [ -n "$HOME_PART" ]; then
    mkdir -p /mnt/home
    mount "$HOME_PART" /mnt/home
fi

echo "Partições montadas com sucesso!"
echo "----------------------------------------------------------"

# === Entra no chroot ===
echo "Entrando no ambiente chroot..."
arch-chroot /mnt /bin/bash <<'EOF'
set -e
echo "----------------------------------------------------------"
echo "Instalando pacotes necessários..."
pacman -Sy --noconfirm grub efibootmgr

echo "Reinstalando o GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --removable

echo "Gerando novo arquivo grub.cfg..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "GRUB reinstalado com sucesso!"
EOF

echo "----------------------------------------------------------"
echo "Saindo do chroot..."
echo "Você pode agora reiniciar o sistema com:"
echo "  reboot"
echo ""
echo "Tudo pronto! É pra funcionar... kkkkk 😎"

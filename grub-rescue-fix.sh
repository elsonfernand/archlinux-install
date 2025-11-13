#!/usr/bin/env bash
# ===========================================================
# 🧭 Arch Linux GRUB Recovery Script
# Autor: Elson Fernandes
# Descrição: Automatiza a reinstalação e correção do GRUB em sistemas EFI.
# ===========================================================

set -e

echo "🔹 Carregando layout ABNT2..."
loadkeys br-abnt2 || true

echo "🔹 Montando partições..."
mount /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p3 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot/efi

echo "🔹 Entrando no ambiente chroot..."
arch-chroot /mnt /bin/bash <<'EOF'
  echo "📦 Reinstalando pacotes essenciais..."
  pacman -Sy --noconfirm grub efibootmgr

  echo "🔁 Reinstalando GRUB..."
  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --removable --recheck

  echo "🧮 Gerando arquivo de configuração..."
  grub-mkconfig -o /boot/grub/grub.cfg

  echo "🧷 Recriando entrada UEFI..."
  efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\EFI\arch_grub\grubx64.efi' || true
EOF

echo "🚪 Saindo do chroot..."
umount -R /mnt

echo "✅ GRUB restaurado com sucesso!"
echo "Reinicie o sistema com: reboot"

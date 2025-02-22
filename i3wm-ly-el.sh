#!/bin/bash

###  _ ____                      ###
### (_)___ \                     ###
###  _  __) |_      ___ __ ___   ###
### | ||__ <\ \ /\ / / '_ ` _ \  ###
### | |___) |\ V  V /| | | | | | ###
### |_|____/  \_/\_/ |_| |_| |_| ###

# Verificação se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root."
  exit
fi

echo "Atualizando os pacotes..."
# Atualização do sistema
pacman -Syu --noconfirm

echo "Instalando i3wm, i3status, i3lock, i3blocks, rofi e ly..."
# Instalando o i3wm, i3status, i3lock, i3blocks, dmenu e o display manager Ly
pacman -S i3-wm i3status i3lock i3blocks rofi ly xorg-xinit xorg lxsession numlockx --noconfirm

echo "Instalando PipeWire e alguns pacotes relevantes ao audio..."
# Instalando PipeWire e alguns pacotes relevantes ao audio #
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol qpwgraph

echo "Instalando ferramentas de mudança de wallpaper..."
# Instala ferramentas de mudança de wallpaper #
pacman -S --noconfirm nitrogen

echo "Instalando emuladores de terminal..."
# Instala emuladores de terminal #
pacman -S --noconfirm xterm alacritty

echo "Instalando ferramentas de tema e ícones..."
# Instala ferramentas de tema e ícones #
pacman -S --noconfirm lxappearance

echo "Instalando aplicativos básicos..."
# Instala barra de tarefas e aplicativos básicos #
pacman -S --noconfirm network-manager-applet xfce4-power-manager 

echo "Instalando utilitários adicionais..."
# Instala utilitários adicionais e gerenciador de arquivos #
pacman -S --noconfirm webp-pixbuf-loader galculator lib32-libx11 arandr scrot dunst volumeicon alsa-utils alsa-plugins gpicview gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc menumaker tumbler ffmpegthumbnailer cdrtools p7zip unrar unzip zip poppler-glib libgsf libgepub libopenraw freetype2 xarchiver vlc archlinux-wallpaper fastfetch picom libxml2 zathura zathura-pdf-mupdf geany geany-plugins telegram-desktop playerctl brightnessctl

# Se o "unrar" não funcionar para compressão em rar você pode instalar o "rar" manualmente pelo AUR
#pacman -S base-devel git
#git clone https://aur.archlinux.org/rar.git
#cd rar
#makepkg -si

echo "Instalando gerenciador de arquivos..."
# Se optar por escolher o Thunar
# pacman -S --noconfirm thunar thunar-archive-plugin thunar-volman thunar-media-tags-plugin 

# Se optar por escolher o PCManFM
pacman -S --noconfirm sudo pacman -S pcmanfm

# Verificação da pasta de configuração do i3 se já existe
I3_CONFIG_DIR="$HOME/.config/i3"
if [ ! -d "$I3_CONFIG_DIR" ]; then
  echo "Criando diretório de configuração do i3..."
  mkdir -p "$I3_CONFIG_DIR"
fi

# Criando o arquivo de configuração padrão do i3, se não existir
I3_CONFIG_FILE="$I3_CONFIG_DIR/config"
if [ ! -f "$I3_CONFIG_FILE" ]; then
  echo "Criando arquivo de configuração padrão do i3..."
  i3-config-wizard
else
  echo "Arquivo de configuração do i3 já existe. Nenhuma mudança necessária."
fi

# Configuracao do startx para iniciar o i3wm
XINITRC="$HOME/.xinitrc"
if ! grep -q "exec i3" "$XINITRC"; then
  echo "Configurando .xinitrc para iniciar o i3wm..."
  echo "exec i3" > "$XINITRC"
else
  echo ".xinitrc já configurado para iniciar o i3wm."
fi

echo "Habilitando o display manager Ly..."
# Habilitando e iniciando o Ly como Display Manager
systemctl enable --now ly.service

echo "Habilitando e iniciando os serviços do PipeWire..."
# Habilita e iniciar os serviços do PipeWire #
systemctl --user enable pipewire.service
systemctl --user start pipewire.service

systemctl --user enable pipewire-pulse.service
systemctl --user start pipewire-pulse.service

systemctl --user enable wireplumber.service
systemctl --user start wireplumber.service

# Instalação de drivers de vídeo #
# Nvidia #
#sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# AMD
sudo pacman -S --noconfirm xf86-video-amdgpu
# Nota: fica mais facil instalar os outros pacotes por um gerenciador do AUR, por exemplo o Yay.
# Os pacotes recomendados pela Arch Wiki sao: amdgpu-pro-oglp, lib32-amdgpu-pro-oglp, vulkan-amdgpu-pro e lib32-vulkan-amdgpu-pro.

echo "Criando diretórios usuais na /home..."
# Por padrão o i3wm não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem #
sudo pacman -S --noconfirm xdg-user-dirs ; xdg-user-dirs-update

echo "Configurando o layout de teclado padrão como br-abnt2 no sistema..."
# Configurar o layout de teclado padrão como br-abnt2 no sistema
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

echo "Instalando alguns temas, cursores e fontes..."
# Instala alguns temas, cursores e fontes #
sudo pacman -S --noconfirm arc-gtk-theme materia-gtk-theme papirus-icon-theme xcursor-vanilla-dmz xcursor-vanilla-dmz-aa noto-fonts-emoji ttf-dejavu ttf-liberation nerd-fonts

echo "Instalando e configurando o Fastfetch..."
# Arquivo do Fastfetch se encontra em ~/.config/fastfetch/config.jsonc e voce pode alterar ele com o nano ou editor de texto de sua preferencia.
# Se quiser, pode usar a pasta com a configuração desse repositório. Só copiar e colar a pasta "fastfetch" para dentro do "~/.config".
sudo pacman -S --noconfirm fastfetch
fastfetch --gen-config

echo "Instalando o Brave Browser..."
# Caso queira instalar o Brave (navegador de código aberto, com bloqueador de anúncios embutido e baseado no Chromium) sem ajudante do AUR #
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm
cd ..
rm -rf brave-bin

# Configurações de Locale
echo "Configurando locales..."
# Descomenta en_US.UTF-8 no arquivo locale.gen
sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

# Gera os locales
sudo locale-gen

# Configura o locale padrão
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
echo 'LC_ALL=en_US.UTF-8' | sudo tee -a /etc/locale.conf

# Exporta as variáveis de locale para a sessão atual
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Adiciona as variáveis de locale ao .bashrc para garantir que sejam configuradas em cada sessão
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
source ~/.bashrc

echo "Locales configurados."

echo "Criando o diretório de configuração do rofi e configurações iniciais..."
# Cria o diretório de configuração do rofi, se não existir
mkdir -p ~/.config/rofi

# Adiciona configuração para mostrar ícones no rofi
cat <<EOL > ~/.config/rofi/config.rasi
configuration {
    show-icons: true;
}
EOL

echo "Instalação e configuração inicial do i3wm e Ly (Display Manager) concluída!"

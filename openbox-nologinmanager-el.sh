#!/bin/bash

# ╭━━━╮╱╱╱╱╱╱╱╱╭╮
# ┃╭━╮┃╱╱╱╱╱╱╱╱┃┃
# ┃┃╱┃┣━━┳━━┳━╮┃╰━┳━━┳╮╭╮
# ┃┃╱┃┃╭╮┃┃━┫╭╮┫╭╮┃╭╮┣╋╋╯
# ┃╰━╯┃╰╯┃┃━┫┃┃┃╰╯┃╰╯┣╋╋╮
# ╰━━━┫╭━┻━━┻╯╰┻━━┻━━┻╯╰╯
# ╱╱╱╱┃┃
# ╱╱╱╱╰╯

# Atualiza o sistema #
sudo pacman -Syu

# Instala o Openbox e algumas ferramentas básicas #
sudo pacman -S --noconfirm openbox xorg-xinit xorg obconf lxsession numlockx

# Instalando PipeWire e alguns pacotes relevantes ao aoudio #
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol qpwgraph

# Instala ferramentas de mudança de wallpaper #
sudo pacman -S --noconfirm nitrogen

# Instala emuladores de terminal #
sudo pacman -S --noconfirm xterm lxterminal

# Instala ferramentas de tema e ícones do Openbox #
sudo pacman -S --noconfirm lxappearance-obconf

# Instala barra de tarefas e aplicativos básicos #
sudo pacman -S --noconfirm tint2 network-manager-applet xfce4-power-manager gsimplecal 

# Instala utilitários adicionais e gerenciador de arquivos #
sudo pacman -S --noconfirm thunar thunar-archive-plugin volumeicon alsa-utils alsa-plugins gpicview gvfs gvfs-mtp gvfs-smb gvfs-gphoto2 gvfs-afc menumaker tumbler ffmpegthumbnailer unzip xarchiver vlc archlinux-wallpaper fastfetch picom libxml2 zathura zathura-pdf-mupdf geany geany-plugins telegram-desktop i3lock playerctl brightnessctl

# Cliente de email
sudo pacman -S --noconfirm thunderbird systray-x-common thunderbird-i18n-pt-br thunderbird-i18n-en-us

# Instala navegador. Descomente a linha da sua preferencia. Eu dou preferencia a navegador baseado no Chromium. #
#sudo pacman -S --noconfirm chromium
#sudo pacman -S --noconfirm firefox

# Habilita e iniciar os serviços do PipeWire #
systemctl --user enable pipewire.service
systemctl --user start pipewire.service

systemctl --user enable pipewire-pulse.service
systemctl --user start pipewire-pulse.service

systemctl --user enable wireplumber.service
systemctl --user start wireplumber.service


# Cria diretórios necessários para funcionamento do Openbox #
#mkdir -p ~/.config/openbox
#mkdir -p ~/.config/tint2

# Instalação de drivers de vídeo #
# Nvidia #
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings


# █▄░█ █░█ █▀▄▀█ █░░ █▀█ █▀▀ █▄▀   ▀█▀ ▀█▀ █▄█
# █░▀█ █▄█ █░▀░█ █▄▄ █▄█ █▄▄ █░█   ░█░ ░█░ ░█░
# Cria script para definir o numlock nos TTYs #
cat <<EOL > /usr/local/bin/numlock
#!/bin/bash

for tty in /dev/tty{1..6}
do
    /usr/bin/setleds -D +num < "$tty";
done
EOL

# Torna o script anterior executável #
sudo chmod +x /usr/local/bin/numlock

# Criação e habilitação de um serviço no SystemD #
cat <<EOL > /etc/systemd/system/numlock.service
[Unit]
Description=Activate numlock on boot

[Service]
ExecStart=/usr/local/bin/numlock
StandardInput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOL

# Habilitação desse serviço #
sudo systemctl enable --now numlock.service

# Cria atalho para iniciar o Openbox e ativação do NumLock #
cat <<EOL > ~/.xinitrc
numlockx on &
exec openbox-session
EOL

# Por padrão o Openbox não tem os diretorios usuais na /home, precisamos instalar e rodar um pacote para os diretorios aparecerem: #
sudo pacman -S --noconfirm xdg-user-dirs ; xdg-user-dirs-update

# Configurar o layout de teclado padrão como br-abnt2 no sistema
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

# Instala alguns temas, cursores e fontes #
sudo pacman -S --noconfirm arc-gtk-theme materia-gtk-theme papirus-icon-theme xcursor-vanilla-dmz xcursor-vanilla-dmz-aa noto-fonts-emoji ttf-dejavu ttf-liberation nerd-fonts

# █▀█ █▀█ █▀▀ █
# █▀▄ █▄█ █▀░ █

# Atualiza os repositórios e instala o rofi
sudo pacman -Syu --noconfirm rofi

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

# Cria o diretório de configuração do Openbox, se não existir
mkdir -p ~/.config/openbox

# Cria o diretório de configuração do rofi, se não existir
mkdir -p ~/.config/rofi

# Adiciona configuração para mostrar ícones no rofi
cat <<EOL > ~/.config/rofi/config.rasi
configuration {
    show-icons: true;
}
EOL

# █▀▄▀█ █▀▀ █▄░█ █░█   █▀█ ▄▀█ █▀▄ █▀█ ▄▀█ █▀█   █▀█ █▀█ █▀▀ █▄░█ █▄▄ █▀█ ▀▄▀
# █░▀░█ ██▄ █░▀█ █▄█   █▀▀ █▀█ █▄▀ █▀▄ █▀█ █▄█   █▄█ █▀▀ ██▄ █░▀█ █▄█ █▄█ █░█

### A PRIMEIRA OPÇÃO É A PADRÃO ###
# Recarrega as configurações do Openbox
openbox --reconfigure

### A SEGUNDA OPÇÃO VEM DIRETO DO AUR E VOCÊ PODE GERAR O MENU COM ICONES  ATRAVÉS DO https://aur.archlinux.org/obmenu-generator.git ###
# Para gerar o menu com ícones é só usar o comando abaixo #
#obmenu-generator -p -i

# ▄▀█ █▀█ ▄▀█ █▄░█ █▀▄ █▀█
# █▀█ █▀▄ █▀█ █░▀█ █▄▀ █▀▄

# Atualiza o sistema e instala o Arandr
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm arandr

# █▀ █▀▀ █▀█ █▀█ ▀█▀
# ▄█ █▄▄ █▀▄ █▄█ ░█░
## Utilitário para tirar screenshot ##
# Instalacao do scrot
sudo pacman -S --noconfirm scrot

# Recarregar a configuração do Openbox
openbox --reconfigure

# █▄▄ █▀█ ▄▀█ █░█ █▀▀   █▄▄ █▀█ █▀█ █░█░█ █▀ █▀▀ █▀█
# █▄█ █▀▄ █▀█ ▀▄▀ ██▄   █▄█ █▀▄ █▄█ ▀▄▀▄▀ ▄█ ██▄ █▀▄

# Caso queira instalar o Brave (navegador de código aberto e com bloqueador de anúncios embutido e baseado no Chromium) sem ajudante do AUR #
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm
cd ..
rm -rf brave-bin

# █▀▀ ▄▀█ █▀ ▀█▀ █▀▀ █▀▀ ▀█▀ █▀▀ █░█
# █▀░ █▀█ ▄█ ░█░ █▀░ ██▄ ░█░ █▄▄ █▀█

# Arquivo do Fastfetch se encontra em ~/.config/fastfetch/config.jsonc e voce pode alterar ele com o nano ou editor de texto de sua preferencia.
# Se quiser, pode usar a pasta com a configuração desse repositório. Só copiar e colar a pasta "fastfetch" para dentro do "~/.config".
sudo pacman -S --noconfirm fastfetch
#fastfetch --gen-config

# Reconfiguração automática do menu do Openbox usando Menumaker #
mmaker -vf openbox
# Lembrete: No AUR existe um pacote chamado "obmenu-generator" que você pode rodar no terminal "obmenu-generator -p -i" pra gerar um menu com icones. Esse eu recomendo fortemente.

# Finaliza a instalação e configuração
echo "Instalação e configuração inicial do Openbox concluídas. Reinicie o sistema para começar a usar."

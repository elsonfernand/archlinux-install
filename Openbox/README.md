#### O que esse script faz, seu moço?

1. Primeiro ele vai atualizar o sistema e logo depois instalar o Openbox junto com algumas ferramentas que eu julguei úteis e que são recomendadas na Wiki do Arch Linux (***obconf***, ***obmenu***, ***lxappearance***, ***tint2***, ***xorg-server***, ***xorg-xinit***). Instala também alguns papéis de parede com o tema "Arch Linux" (com o pacote ***archlinux-wallpaper***). Instala também o *LightDM* com o greeter GTK.
2. Como gerenciador de arquivos eu optei pelo *PCManFM* e pacotes do GVFS (***gvfs***, ***gvfs-mtp***, ***gvfs-smb***, ***gvfs-gphoto2***, ***gvfs-afc***) com suporte a miniaturas.
3. Vai instalar o ***lxterminal***, um emulador de terminal de minha escolha (você também pode usar o *termite*, *alacritty*, *tilix*, *kitty*, *terminator*, *konsole* ou um de sua preferência).
4. Vai instalar o PipeWire e alguns pacotes necessários (***pipewire***, ***pipewire-alsa***, ***pipewire-pulse***, ***pipewire-jack***, ***wireplumber***, ***pavucontrol***).
5. Instala o Menumaker para geração automática de menus.
6. Certifica que o ***git***, ***go*** e ***base-devel*** estão instalados (se não estiver eles serão reinstalados), clona o repositório do Yay, ajusta permissões, compila e instala.
7. Te pergunta ao qual driver de vídeo deseja instalar: AMD (***xf86-video-amdgpu***), Nvidia (***nvidia***, ***nvidia-utils***) ou VirtualBox (***virtualbox-guest-utils***). O driver escolhido é então instalado e configurado.
8. Habilita e inicia os serviços do PipeWire e WirePlumber.
9. No balaio também vai habilitar o LightDM para iniciar automaticamente no *boot*.
10. Criação de um diretório de configuração para o Openbox em ***~/.config/openbox***.
11. Criação de um arquivo *autostart* básico que inicia o ***Tint2*** (painel), ***Parcellite*** (gerenciador de área de transferência), ***Nitrogen*** (ferramenta para escolha do papel de parede) e ***LXAppearance-Obconf*** (ferramenta para ajustar a aparência do GTK e configurar o Openbox).
12. Criação de um arquivo de sessão do *Openbox* para o *LightDM* em ***/usr/share/xsessions***.
13. Configuração do *PCManFM* para suportar visualização de miniaturas, criando o arquivo *pcmanfm.conf* em ***~/.config/pcmanfm/default***.
14. Reconfigura o menu do Openbox usando o Menumaker com o comando ***mmaker -vf openbox***.

Para usar o script, torne-o executável:

```
chmod +x openbox-el.sh
```
E execute-o:
```
./openbox-el.sh
```

Depois de executar o script, reinicie o sistema para iniciar o LightDM. Termine o resto da sua instalação com o *lxterminal* pra instalar outros programas de sua escolha. Essa é a base para o meu uso.

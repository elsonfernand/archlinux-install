#!/bin/bash

# Cria diretórios necessários, se não existirem
[ ! -d ~/.config/openbox ] && mkdir -p ~/.config/openbox
[ ! -d ~/.config/tint2 ] && mkdir -p ~/.config/tint2

# Criando arquivo de autostart do Openbox
cat <<EOL > ~/.config/openbox/autostart
# Iniciar ferramentas no login
tint2 &
volumeicon &
nm-applet &
xfce4-power-manager &
feh --bg-scale /caminho/para/seu/wallpaper.jpg &
EOL

# Criando arquivo de menu do Openbox
cat <<EOL > ~/.config/openbox/menu.xml
<openbox_menu>
    <menu id="root-menu" label="Openbox 3">
        <item label="Terminal">
            <action name="Execute">
                <command>xfce4-terminal</command>
            </action>
        </item>
        <item label="Navegador">
            <action name="Execute">
                <command>firefox</command>
            </action>
        </item>
        <separator />
        <item label="Reconfigurar">
            <action name="Reconfigure" />
        </item>
        <item label="Reiniciar">
            <action name="Execute">
                <command>reboot</command>
            </action>
        </item>
        <item label="Desligar">
            <action name="Execute">
                <command>poweroff</command>
            </action>
        </item>
        <separator />
        <item label="Logout">
            <action name="Exit" />
        </item>
    </menu>
</openbox_menu>
EOL

# Criar arquivo de configuração rc.xml do Openbox
cat <<EOL > ~/.config/openbox/rc.xml
<openbox_config>
    <mouse>
        <context name="Frame">
            <mousebind button="A-Left" action="Press">
                <action name="Focus" />
                <action name="Raise" />
                <action name="Move" />
            </mousebind>
            <mousebind button="A-Right" action="Press">
                <action name="Focus" />
                <action name="Raise" />
                <action name="Resize" />
            </mousebind>
        </context>
    </mouse>
    <keyboard>
        <keybind key="A-F4">
            <action name="Close" />
        </keybind>
        <keybind key="W-Return">
            <action name="Execute">
                <command>xfce4-terminal</command>
            </action>
        </keybind>
        <keybind key="W-d">
            <action name="ShowDesktop" />
        </keybind>
    </keyboard>
</openbox_config>
EOL

# Criar arquivo de configuração do Tint2
cat <<EOL > ~/.config/tint2/tint2rc
# Configurações básicas do tint2
panel_monitor = 1
panel_position = top center
panel_size = 100% 40
panel_margin = 0 0
panel_padding = 0 0 0
panel_background_id = 1
wm_menu = 1
EOL

# Criar atalho para iniciar o Openbox
echo "exec openbox-session" > ~/.xinitrc

# Finalizar a configuração
echo "Configuração do Openbox concluída."

#!/bin/bash

# Função para verificar se o script está sendo executado como root
function check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Por favor, execute este script como root."
        exit 1
    fi
}

# Função para instalar o pacote numlockx
function install_numlockx() {
    echo "Instalando o pacote numlockx..."
    pacman -S --noconfirm numlockx
}

# Função para criar o script numlock em /usr/local/bin/
function create_numlock_script() {
    echo "Criando o script /usr/local/bin/numlock..."
    cat << 'EOF' > /usr/local/bin/numlock
#!/bin/bash

for tty in /dev/tty{1..6}
do
    /usr/bin/setleds -D +num < "$tty";
done
EOF
    chmod +x /usr/local/bin/numlock
}

# Função para criar o arquivo de serviço systemd
function create_systemd_service() {
    echo "Criando o serviço systemd /etc/systemd/system/numlock.service..."
    cat << 'EOF' > /etc/systemd/system/numlock.service
[Unit]
Description=numlock

[Service]
ExecStart=/usr/local/bin/numlock
StandardInput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
}

# Função para habilitar e iniciar o serviço systemd
function enable_and_start_service() {
    echo "Habilitando e iniciando o serviço numlock.service..."
    systemctl enable --now numlock.service
}

# Função para verificar o status do serviço
function check_service_status() {
    echo "Verificando o status do serviço numlock.service..."
    systemctl status numlock.service
}

# Fluxo principal
check_root
install_numlockx
create_numlock_script
create_systemd_service
enable_and_start_service
check_service_status

echo "Configuração completa. O NumLock deve estar ativado em todas as TTYs."

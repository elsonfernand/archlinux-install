#!/usr/bin/env python3
# ~/.config/waybar/scripts/ws-watch.py
# Escuta os eventos do Hyprland e manda um sinal (RTMIN+8) para a Waybar
# atualizar os módulos de workspace NA HORA, sem esperar o intervalo de polling.
# Iniciado pelo próprio módulo "custom/wswatch" da Waybar. Usa só a biblioteca padrão.

import fcntl
import glob
import os
import select
import socket
import subprocess
import sys
import time

RUNTIME = os.environ.get("XDG_RUNTIME_DIR", "/tmp")
CACHE = os.path.join(RUNTIME, "waybar-ws.cache")
DEBOUNCE = 0.04  # junta rajadas de eventos (ex.: scroll rápido) em uma só atualização

# Eventos que alteram o que a barra de workspaces mostra
EVENTS = (
    "workspace",        # cobre workspace>> e workspacev2>>
    "createworkspace",
    "destroyworkspace",
    "moveworkspace",
    "openwindow",
    "closewindow",
    "movewindow",
    "focusedmon",
)

# Instância única (se a Waybar for reiniciada, um watcher antigo pode continuar vivo)
lock = open(os.path.join(RUNTIME, "waybar-ws-watch.lock"), "w")
try:
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
except OSError:
    sys.exit(0)


def socket_path():
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if sig:
        return os.path.join(RUNTIME, "hypr", sig, ".socket2.sock")
    socks = glob.glob(os.path.join(RUNTIME, "hypr", "*", ".socket2.sock"))
    return max(socks, key=os.path.getmtime) if socks else None


def refresh():
    try:
        os.remove(CACHE)  # invalida o cache compartilhado do ws.sh
    except FileNotFoundError:
        pass
    subprocess.run(["pkill", "-RTMIN+8", "-x", "waybar"], check=False)


while True:
    path = socket_path()
    try:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(path)
    except (OSError, TypeError):
        time.sleep(2)
        continue

    buf = b""
    deadline = None
    try:
        while True:
            now = time.monotonic()
            if deadline is not None and now >= deadline:
                refresh()
                deadline = None
            timeout = None if deadline is None else max(0.0, deadline - now)
            ready, _, _ = select.select([sock], [], [], timeout)
            if not ready:
                continue
            data = sock.recv(65536)
            if not data:
                break  # Hyprland fechou o socket
            buf += data
            *lines, buf = buf.split(b"\n")
            for line in lines:
                if line.decode(errors="ignore").startswith(EVENTS) and deadline is None:
                    deadline = time.monotonic() + DEBOUNCE
    except OSError:
        pass
    finally:
        sock.close()
    time.sleep(1)

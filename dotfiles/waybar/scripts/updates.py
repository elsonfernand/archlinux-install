#!/usr/bin/env python3
# ~/.config/waybar/scripts/updates.py
# Mostra na Waybar quantas atualizações estão pendentes (repositórios oficiais + AUR).
# Só aparece quando há algo a atualizar, como o ícone do KDE Plasma.
#
# Requer: pacman-contrib (checkupdates). Para a AUR usa yay ou paru, se existirem.
# O checkupdates trabalha numa cópia temporária do banco de dados, então verificar
# NUNCA deixa o sistema em "atualização parcial" (ao contrário de rodar 'pacman -Sy').
# Obs.: pacotes -git (os que o 'yay --devel' atualiza) não entram na contagem.

import json
import os
import shutil
import subprocess
import time

ICON = "󰚰"
MAX_LINES = 15          # linhas por seção no tooltip
ATTEMPTS = 3            # tentativas (a rede pode ainda não estar pronta no boot)
RETRY_DELAY = float(os.environ.get("WAYBAR_UPDATES_RETRY_DELAY", "10"))


def run(cmd, timeout=90):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return p.returncode, p.stdout
    except (OSError, subprocess.TimeoutExpired):
        return None, ""


def check_repo():
    """Retorna (lista de atualizações | None, erro | None)."""
    if not shutil.which("checkupdates"):
        return None, "O comando 'checkupdates' não foi encontrado (instale o pacman-contrib)."
    for i in range(ATTEMPTS):
        rc, out = run(["checkupdates"])
        if rc == 0:
            return [l for l in out.splitlines() if " -> " in l], None
        if rc == 2:                      # 2 = nenhuma atualização
            return [], None
        if i < ATTEMPTS - 1:
            time.sleep(RETRY_DELAY)
    return None, "Falha ao verificar os repositórios oficiais (sem rede?)."


def check_aur():
    helper = shutil.which("yay") or shutil.which("paru")
    if not helper:                       # sem helper: simplesmente não verifica a AUR
        return [], None
    for i in range(ATTEMPTS):
        rc, out = run([helper, "-Qua"])
        if rc in (0, 1):                 # 1 = nada a atualizar
            return [l for l in out.splitlines() if " -> " in l], None
        if i < ATTEMPTS - 1:
            time.sleep(RETRY_DELAY)
    return None, "Falha ao verificar a AUR (sem rede?)."


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def section(title, items):
    lines = [f"<b>{title} ({len(items)})</b>"]
    lines += [esc(l) for l in items[:MAX_LINES]]
    if len(items) > MAX_LINES:
        lines.append(f"… e mais {len(items) - MAX_LINES}")
    return "\n".join(lines)


repo, err_repo = check_repo()
aur, err_aur = check_aur()
errors = [e for e in (err_repo, err_aur) if e]
total = len(repo or []) + len(aur or [])

if total == 0 and not errors:
    out = {"text": ""}                   # texto vazio = módulo escondido
else:
    parts = []
    if repo:
        parts.append(section("Repositórios oficiais", repo))
    if aur:
        parts.append(section("AUR", aur))
    parts += [f"<i>{esc(e)}</i>" for e in errors]
    parts.append("<small>Clique: atualizar (maintain)  ·  Botão direito: verificar de novo</small>")
    if total:
        out = {"text": f"{ICON} {total}", "tooltip": "\n\n".join(parts), "class": "updates"}
    else:
        out = {"text": f"{ICON} ?", "tooltip": "\n\n".join(parts), "class": "error"}

print(json.dumps(out, ensure_ascii=False))

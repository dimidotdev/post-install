#!/usr/bin/env bash
set -euo pipefail

SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive

echo "--> Instalando ferramentas modernas de produtividade CLI..."
$SUDO apt-get install -y --no-install-recommends \
    tmux \
    htop \
    btop \
    ripgrep \
    fd-find \
    fzf \
    bat \
    neovim

echo "--> Criando symlinks padronizados (/usr/local/bin/bat e fd)..."
$SUDO mkdir -p /usr/local/bin

if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    $SUDO ln -sf "$(command -v batcat)" /usr/local/bin/bat
    echo "  -> Symlink criado: /usr/local/bin/bat"
fi

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    echo "  -> Symlink criado: /usr/local/bin/fd"
fi

$SUDO apt-get clean

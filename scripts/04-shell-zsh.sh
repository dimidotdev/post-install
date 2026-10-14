#!/usr/bin/env bash
set -euo pipefail

SUDO=""
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "${TARGET_USER}" | cut -d: -f6)
if [ -z "${TARGET_HOME}" ]; then
    TARGET_HOME="$HOME"
fi

if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive

echo "--> Garantindo instalação do Zsh..."
$SUDO apt-get install -y zsh

# Instalar Oh My Zsh se ainda não existir
OMZ_DIR="${TARGET_HOME}/.oh-my-zsh"
if [ ! -d "${OMZ_DIR}" ]; then
    echo "--> Instalando Oh My Zsh de forma autônoma..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    echo "--> Oh My Zsh instalado com sucesso."
else
    echo "--> Oh My Zsh já está instalado em ${OMZ_DIR}."
fi

ZSH_CUSTOM="${OMZ_DIR}/custom"
mkdir -p "${ZSH_CUSTOM}/plugins"

# Instalar zsh-autosuggestions
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
if [ ! -d "${AUTOSUGGESTIONS_DIR}" ]; then
    echo "--> Clonando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${AUTOSUGGESTIONS_DIR}"
else
    echo "--> zsh-autosuggestions já instalado."
fi

# Instalar zsh-syntax-highlighting
SYNTAX_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
if [ ! -d "${SYNTAX_DIR}" ]; then
    echo "--> Clonando zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${SYNTAX_DIR}"
else
    echo "--> zsh-syntax-highlighting já instalado."
fi

# Garantir que a linha de plugins no ~/.zshrc carregue os plugins desejados
ZSHRC="${TARGET_HOME}/.zshrc"
if [ -f "${ZSHRC}" ]; then
    if grep -q "^plugins=" "${ZSHRC}"; then
        sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "${ZSHRC}"
    else
        echo "plugins=(git zsh-syntax-highlighting zsh-autosuggestions)" >> "${ZSHRC}"
    fi
fi

# Copiar arquivo de aliases se existir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIASES_SRC="${SCRIPT_DIR}/../configs/aliases.zsh"
if [ -f "${ALIASES_SRC}" ]; then
    cp "${ALIASES_SRC}" "${ZSH_CUSTOM}/aliases.zsh"
    echo "--> Aliases personalizados copiados para ${ZSH_CUSTOM}/aliases.zsh"
fi

# Ajustar shell padrão para Zsh caso não seja
ZSH_BIN="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_BIN" ]; then
    echo "--> Definindo Zsh como shell padrão para ${TARGET_USER}..."
    $SUDO chsh -s "$ZSH_BIN" "${TARGET_USER}" 2>/dev/null || true
fi


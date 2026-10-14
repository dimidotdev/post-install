#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "${TARGET_USER}" | cut -d: -f6)
if [ -z "${TARGET_HOME}" ]; then
    TARGET_HOME="$HOME"
fi

export NVM_DIR="${TARGET_HOME}/.nvm"

echo "--> Verificando instalação do NVM..."
if [ ! -d "${NVM_DIR}" ]; then
    echo "--> Baixando e instalando NVM v0.40.1..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    echo "--> NVM já está instalado em ${NVM_DIR}."
fi

# Carregar NVM
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

echo "--> Instalando versão Node.js LTS via NVM..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo "--> Node $(node -v) e NPM $(npm -v) ativos."

echo "--> Instalando pacotes globais para stacks (React/Next/Angular/Nest/Cloudflare)..."
npm install -g \
    pnpm \
    wrangler \
    @angular/cli \
    @nestjs/cli

# Garantir snippet no .zshrc
ZSHRC="${TARGET_HOME}/.zshrc"
if [ -f "${ZSHRC}" ]; then
    if ! grep -q 'NVM_DIR="$HOME/.nvm"' "${ZSHRC}"; then
        echo "" >> "${ZSHRC}"
        echo '# Node Version Manager (NVM)' >> "${ZSHRC}"
        echo 'export NVM_DIR="$HOME/.nvm"' >> "${ZSHRC}"
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "${ZSHRC}"
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> "${ZSHRC}"
    fi
fi

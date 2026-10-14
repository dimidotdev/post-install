#!/usr/bin/env bash
set -euo pipefail

SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive

echo "--> Atualizando listas de pacotes do APT..."
$SUDO apt-get update -y

echo "--> Instalando pacotes base, compiladores e utilitários de sistema..."
$SUDO apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    cmake \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    unzip \
    zip \
    p7zip-full \
    tree \
    jq \
    git \
    git-lfs \
    python3-pip \
    python3-venv \
    software-properties-common

# Inicializar Git LFS
git lfs install --system 2>/dev/null || git lfs install 2>/dev/null || true

echo "--> Limpeza de cache APT..."
$SUDO apt-get clean

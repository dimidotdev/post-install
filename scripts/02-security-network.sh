#!/usr/bin/env bash
set -euo pipefail

SUDO=""
TARGET_USER="${SUDO_USER:-$USER}"
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive

echo "--> Pré-configurando permissões não-interativas para Wireshark/TShark..."
echo "wireshark-common wireshark-common/install-setuid boolean true" | $SUDO debconf-set-selections

echo "--> Instalando ferramentas de auditoria de rede e segurança cibernética..."
$SUDO apt-get install -y --no-install-recommends \
    tshark \
    wireshark-common \
    nmap \
    tcpdump \
    mtr-tiny \
    iftop \
    nethogs \
    arp-scan \
    netcat-openbsd \
    socat \
    iperf3 \
    net-tools \
    dnsutils \
    iputils-ping \
    traceroute

# Adicionar usuário ao grupo wireshark para capturar pacotes sem root
if getent group wireshark >/dev/null 2>&1; then
    $SUDO usermod -aG wireshark "${TARGET_USER}" 2>/dev/null || true
    echo "--> Usuário ${TARGET_USER} adicionado ao grupo wireshark."
fi

$SUDO apt-get clean

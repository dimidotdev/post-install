#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "${TARGET_USER}" | cut -d: -f6)
if [ -z "${TARGET_HOME}" ]; then
    TARGET_HOME="$HOME"
fi

export SDKMAN_DIR="${TARGET_HOME}/.sdkman"

echo "--> Verificando instalação do SDKMAN..."
if [ ! -d "${SDKMAN_DIR}" ]; then
    echo "--> Baixando e instalando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
else
    echo "--> SDKMAN já está instalado em ${SDKMAN_DIR}."
fi

# Configurar auto-answer para execuções automatizadas
if [ -f "${SDKMAN_DIR}/etc/config" ]; then
    sed -i 's/sdkman_auto_answer=false/sdkman_auto_answer=true/' "${SDKMAN_DIR}/etc/config"
fi

# Inicializar SDKMAN
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

echo "--> Instalando Apache Maven via SDKMAN..."
sdk install maven || true

echo "--> Instalando OpenJDK LTS (Eclipse Temurin) via SDKMAN..."
# Instala a versão LTS padrão (Java 25)
sdk install java 25.0.4-tem || sdk install java || true

# Opcional: Instalar também Java 21 LTS para compatibilidade ampla com frameworks legados
sdk install java 21.0.12+1.1-tem 2>/dev/null || true

# Definir Java 25 LTS como default
sdk default java 25.0.4-tem 2>/dev/null || true

echo "--> Java ativo: $(java -version 2>&1 | head -n 1)"
echo "--> Maven ativo: $(mvn -version 2>&1 | head -n 1)"

# Garantir snippet no .zshrc
ZSHRC="${TARGET_HOME}/.zshrc"
if [ -f "${ZSHRC}" ]; then
    if ! grep -q 'SDKMAN_DIR="$HOME/.sdkman"' "${ZSHRC}"; then
        echo "" >> "${ZSHRC}"
        echo '# SDKMAN' >> "${ZSHRC}"
        echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "${ZSHRC}"
        echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "${ZSHRC}"
    fi
fi

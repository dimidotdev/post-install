#!/usr/bin/env bash
# ==============================================================================
# Master Post-Install Script - Debian / Ubuntu (WSL & Servidores)
# Mantenedor: Matheus Silva (@dimidotdev)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DEBIAN_FRONTEND=noninteractive

# Cores para formatação de logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Verificar se sudo está acessível
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            SUDO="sudo"
        else
            log_error "Este script requer privilégios de root ou o comando sudo instalado."
            exit 1
        fi
    else
        SUDO=""
    fi
}

run_step() {
    local script_name="$1"
    local desc="$2"
    local script_path="${SCRIPT_DIR}/scripts/${script_name}"

    echo ""
    echo "=========================================================="
    log_info "Etapa: ${desc}"
    echo "=========================================================="

    if [ -f "${script_path}" ]; then
        chmod +x "${script_path}"
        bash "${script_path}"
        log_success "${desc} concluído!"
    else
        log_error "Script não encontrado: ${script_path}"
        exit 1
    fi
}

main() {
    echo "=========================================================="
    echo "   Iniciando Post-Install Dev & Cyber Environment        "
    echo "   Usuário: $(whoami) | Host: $(hostname)                "
    echo "=========================================================="

    check_sudo

    run_step "01-base-packages.sh" "Instalação de Pacotes Base e Compilação"
    run_step "02-security-network.sh" "Ferramentas de Cibersegurança e Redes"
    run_step "03-modern-cli.sh" "Produtividade Moderna no Terminal (CLI)"
    run_step "04-shell-zsh.sh" "Configuração do Zsh, Oh My Zsh e Plugins"
    run_step "05-nvm-node.sh" "NVM, Node LTS e CLIs (pnpm, wrangler, Angular, Nest)"
    run_step "06-sdkman-java.sh" "SDKMAN, Java LTS (Temurin) e Maven (Vaadin Stack)"

    echo ""
    echo "=========================================================="
    log_success "Instalação concluída com sucesso!"
    echo "=========================================================="
    echo -e "${YELLOW}Dica:${NC} Para carregar todas as variáveis no terminal atual, execute:"
    echo "  exec zsh"
    echo ""
}

main "$@"

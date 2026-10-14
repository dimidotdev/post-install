# 🚀 Post-Install & Dev Environment Setup

Repositório pessoal de automação de pós-instalação para distribuições baseadas em **Debian e Ubuntu**, otimizado para **WSL2** e **Servidores de Produção/VPS**.

Desenvolvido e mantido por **Matheus Silva** ([@dimidotdev](https://github.com/dimidotdev)).

---

## 📋 Sumário
- [Visão Geral](#-visão-geral)
- [Instalação Rápida](#-instalação-rápida)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Stack de Desenvolvimento Suportada](#-stack-de-desenvolvimento-suportada)
- [Documentação das Ferramentas](#-documentação-das-ferramentas)
  - [1. Compilação e Utilitários Base](#1-compilação-e-utilitários-base)
  - [2. Cibersegurança e Diagnóstico de Redes](#2-cibersegurança-e-diagnóstico-de-redes)
  - [3. Produtividade Moderna de Terminal (CLI)](#3-produtividade-moderna-de-terminal-cli)
  - [4. Shell Zsh e Plugins](#4-shell-zsh-e-plugins)
  - [5. Runtimes: Node.js (NVM) e Java (SDKMAN)](#5-runtimes-nodejs-nvm-e-java-sdkman)
- [Aliases de Produtividade](#-aliases-de-produtividade)
- [Uso em Servidores Remotos (VPS)](#-uso-em-servidores-remotos-vps)
- [Idempotência e Segurança](#-idempotência-e-segurança)

---

## 🎯 Visão Geral

Este projeto automatiza a configuração inicial de um sistema operacional recém-instalado, garantindo um ambiente pronto para desenvolvimento de alta performance, auditoria de redes e segurança, sem dependências manuais ou diálogos interativos travando a instalação.

Principais destaques:
* **Totalmente não-interativo**: Pré-configura permissões (ex: `wireshark-common/install-setuid`) para evitar telas de confirmação no terminal.
* **Idempotente**: Pode ser executado repetidas vezes sem duplicar linhas no `.zshrc` ou reinstalar pacotes já presentes.
* **Modular**: Cada subsistema possui seu próprio script em `scripts/`, orquestrado pelo `install.sh`.

---

## ⚡ Instalação Rápida

### Opção 1: Clonar e Executar (Recomendado)

```bash
# 1. Clonar o repositório
git clone https://github.com/dimidotdev/post-install.git ~/post-install
cd ~/post-install

# 2. Dar permissão de execução
chmod +x install.sh scripts/*.sh

# 3. Executar o instalador
./install.sh

# 4. Atualizar a sessão do shell
exec zsh
```

---

## 📂 Estrutura do Repositório

```text
post-install/
├── install.sh                  # Orquestrador master de execução
├── README.md                   # Documentação detalhada de cada componente
├── scripts/
│   ├── 01-base-packages.sh     # Compiladores, build tools e utilitários base
│   ├── 02-security-network.sh  # Wireshark (tshark), nmap, tcpdump, monitoramento de rede
│   ├── 03-modern-cli.sh        # ripgrep, fd, fzf, bat, tmux, btop, neovim
│   ├── 04-shell-zsh.sh         # Zsh, Oh My Zsh, plugins e aliases
│   ├── 05-nvm-node.sh          # NVM, Node LTS, pnpm, wrangler, Angular, NestJS
│   └── 06-sdkman-java.sh       # SDKMAN, Java LTS (Eclipse Temurin) e Apache Maven
└── configs/
    ├── .zshrc.template         # Modelo de configuração para o Zsh
    └── aliases.zsh             # Atalhos de produtividade para terminal
```

---

## 🛠️ Stack de Desenvolvimento Suportada

Este ambiente foi planejado sob medida para atender as seguintes stacks e fluxos de trabalho:

| Tecnologia | Recursos / Ferramentas Instaladas |
| :--- | :--- |
| **Java & Vaadin** | OpenJDK LTS (Eclipse Temurin 25 e 21), Apache Maven 3.10+ via SDKMAN, Node.js para Vite/frontend |
| **React & Next.js** | Node.js LTS via NVM, `npm`, `pnpm` (gerenciador rápido e econômico de disco) |
| **Angular** | `@angular/cli` (`ng`) instalado globalmente |
| **NestJS** | `@nestjs/cli` (`nest`) instalado globalmente para geração de APIs e microsserviços |
| **Cloudflare Workers** | Cloudflare `wrangler` CLI global para desenvolvimento e deploy de Workers, Pages e D1 |
| **VS Code** | Integração com WSL Remote (`code .`), variáveis de ambiente e compiladores C/C++ prontos |

---

## 📚 Documentação das Ferramentas

### 1. Compilação e Utilitários Base
* **`build-essential`, `gcc`, `g++`, `make`, `cmake`**: Compiladores C/C++ e ferramentas padrão de compilação nativa (essenciais para compilar módulos nativos do Node, gems ou extensões).
* **`pkg-config`**: Auxiliar para localização de bibliotecas no sistema durante compilações.
* **`git` & `git-lfs`**: Controle de versão moderno com suporte a arquivos binários e modelos pesados (Large File Storage).
* **`curl` & `wget`**: Utilitários para download de binários, requisições HTTP e automação de scripts.
* **`jq`**: Processador de JSON leve e flexível para manipulação via terminal e scripts bash.
* **`tree`**: Exibição recursiva da árvore de diretórios com suporte a cores e filtros.
* **`zip`, `unzip`, `p7zip-full`**: Pacotes completos para manipulação e extração de formatos compactados (.zip, .7z, .tar, .gz).
* **`python3-pip` & `python3-venv`**: Gestor de pacotes Python e suporte a ambientes virtuais isolados (`venv`).

---

### 2. Cibersegurança e Diagnóstico de Redes
* **`tshark`**: Interface de linha de comando oficial do **Wireshark**. Permite capturar, filtrar e decodificar tráfego de pacotes diretamente no terminal ou analisar arquivos `.pcap` sem necessidade de interface gráfica.
* **`nmap`**: O padrão da indústria em exploração de rede e auditoria de segurança. Permite descoberta de hosts, detecção de portas abertas, fingerprinting de serviços/OS e execução de scripts de vulnerabilidade (NSE).
* **`tcpdump`**: Analisador e capturador de pacotes de baixo nível em tempo real, ideal para depuração rápida de problemas de conectividade.
* **`mtr-tiny`**: Ferramenta interativa que combina o poder do `traceroute` e do `ping` em uma única visão, medindo latência e percentual de perda em cada salto da rota.
* **`iftop`**: Exibe o consumo de largura de banda em tempo real organizado por pares de conexão IP/porta.
* **`nethogs`**: Monitor de largura de banda que agrupa o tráfego por **Processo (PID)**, permitindo identificar imediatamente qual aplicação está saturando a rede.
* **`arp-scan`**: Varredura ativa na camada de enlace (ARP) para descobrir instantaneamente todos os dispositivos e seus endereços MAC na rede local.
* **`netcat-openbsd` (`nc`) & `socat`**: "Canivetes suíços" de redes para escutar em portas, criar tunnels bidirecionais, redirecionar tráfego e testar sockets TCP/UDP.
* **`iperf3`**: Utilitário para medir a vazão máxima de largura de banda (throughput) entre dois pontos de rede.
* **`net-tools` & `dnsutils`**: Conjunto de ferramentas clássicas como `netstat`, `ifconfig`, `dig`, `nslookup` e `host`.

---

### 3. Produtividade Moderna de Terminal (CLI)
* **`ripgrep` (`rg`)**: Substituto ultrarrápido para o `grep`. Escaneia projetos inteiros respeitando regras do `.gitignore` por padrão e com suporte total a regex Unicode.
* **`fd-find` (`fd`)**: Alternativa simples, rápida e amigável ao comando `find`. O script cria automaticamente o symlink `/usr/local/bin/fd`.
* **`fzf`**: Localizador fuzzy interativo que transforma qualquer busca (arquivos, histórico, processos, branches git) em uma experiência dinâmica.
* **`bat`**: Substituto do `cat` com syntax highlighting para dezenas de linguagens, números de linha e integração visual com alterações do Git. O script cria o symlink `/usr/local/bin/bat`.
* **`tmux`**: Multiplexador de terminal que permite criar múltiplos painéis e manter sessões persistentes ativas mesmo após desconexão SSH.
* **`btop` & `htop`**: Monitores interativos e visuais de recursos (CPU, memória, processos, discos e rede) com suporte a mouse e gráficos em tempo real.
* **`neovim` (`nvim`)**: Editor de texto de alta velocidade baseado no Vim, ideal para alterações rápidas ou como IDE de terminal.

---

### 4. Shell Zsh e Plugins
* **Zsh**: Shell avançado com suporte nativo a autocompletion inteligente e extensibilidade.
* **Oh My Zsh**: Framework comunitário para gerenciamento de configurações, temas e plugins do Zsh.
* **`zsh-autosuggestions`**: Sugere comandos em tempo real com base no seu histórico enquanto você digita.
* **`zsh-syntax-highlighting`**: Colore comandos válidos em verde e erros de digitação em vermelho antes mesmo de você pressionar Enter.

---

### 5. Runtimes: Node.js (NVM) e Java (SDKMAN)

#### Node.js via NVM (Node Version Manager)
O script instala o NVM v0.40+, baixa a versão **Node.js LTS** mais recente e configura como versão default. Em seguida, instala os utilitários globais:
* **`pnpm`**: Gerenciador de pacotes performático e que economiza espaço em disco através de hardlinks.
* **`wrangler`**: CLI da Cloudflare para desenvolvimento e deploy de Workers, Pages, KV e D1.
* **`@angular/cli`**: CLI oficial para projetos Angular (`ng`).
* **`@nestjs/cli`**: CLI oficial para arquitetura corporativa NestJS (`nest`).

#### Java & Maven via SDKMAN
O script instala o **SDKMAN** em modo silencioso (`sdkman_auto_answer=true`) e configura:
* **Java LTS (Eclipse Temurin)**:
  * Java 25 LTS (versão padrão de longo suporte mais recente)
  * Java 21 LTS (compatibilidade ampla com ecossistemas Spring Boot / Vaadin)
* **Apache Maven 3.10+**: Gerenciador de dependências e build do ecossistema Java.

Para alternar entre versões de Java no dia a dia:
```bash
sdk use java 21.0.12+1.1-tem   # Usar temporariamente nesta aba
sdk default java 25.0.4-tem    # Definir como padrão permanente
```

---

## ⌨️ Aliases de Produtividade

O arquivo `configs/aliases.zsh` é carregado automaticamente pelo Oh My Zsh e fornece os seguintes atalhos:

| Atalho | Comando Equivalente | Descrição |
| :--- | :--- | :--- |
| `cat` | `bat -p` | Exibe arquivos com syntax highlighting sem paginação |
| `ll` / `la` | `ls -lah` / `ls -A` | Listagem detalhada de arquivos com arquivos ocultos |
| `gs` / `gaa` / `gc` | `git status` / `git add --all` / `git commit -m` | Atalhos rápidos de Git |
| `gp` / `gpl` | `git push` / `git pull` | Envio e sincronização com repositório remoto |
| `pn` / `px` | `pnpm` / `pnpm dlx` | Execução do pnpm |
| `w` / `wd` / `wp` | `wrangler` / `wrangler dev` / `wrangler deploy` | Desenvolvimento e deploy no Cloudflare |
| `mci` / `mcist` | `mvn clean install` / `-DskipTests` | Compilação Maven (Vaadin / Spring) |
| `msb` | `mvn spring-boot:run` | Execução de aplicação Spring Boot / Vaadin |
| `ports` | `sudo netstat -tulpn \| grep LISTEN` | Lista todas as portas em escuta na máquina |
| `myip` / `localip` | Detecção de IP | Exibe IP público e IP da interface local |
| `scan` | `sudo nmap -sC -sV` | Varredura de serviços com Nmap |
| `sniff` | `sudo tshark -i any` | Captura de tráfego de rede via TShark |

---

## 🌐 Uso em Servidores Remotos (VPS)

Para replicar exatamente a mesma estrutura em um servidor Debian 12/13 ou Ubuntu 22.04/24.04 recém-criado:

```bash
# Conecte no servidor
ssh root@seu-servidor-ip

# Instale o git básico
apt update && apt install -y git

# Clone o repositório e execute
git clone https://github.com/dimidotdev/post-install.git ~/post-install
cd ~/post-install
chmod +x install.sh scripts/*.sh
./install.sh
```

---

## 🔒 Idempotência e Segurança

* Todas as verificações checam diretórios e comandos antes de baixar ou clonar novamente (`[ ! -d ... ]`).
* O arquivo `.zshrc` recebe verificações com `grep` para nunca duplicar blocos de código ou exportações do NVM e SDKMAN.
* Os pacotes são instalados com repositórios oficiais e chaves de segurança validadas pelo APT.

---

Feito com ☕ por [Matheus Silva (@dimidotdev)](https://github.com/dimidotdev).

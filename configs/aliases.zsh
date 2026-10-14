# ==============================================================================
# Aliases Personalizados para Produtividade - Matheus Silva (@dimidotdev)
# ==============================================================================

# Navegação & Utilitários Modernos
alias cat="bat -p"
alias ls="ls --color=auto"
alias ll="ls -lah"
alias la="ls -A"
alias grep="rg"
alias find="fd"

# Git & GitHub
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias gl="git log --oneline --graph --decorate"
alias gpr="gh pr create"
alias gpv="gh pr view"

# Node.js & Full-Stack (React / Next / Angular / Nest / Cloudflare)
alias pn="pnpm"
alias px="pnpm dlx"
alias nrd="npm run dev"
alias nrb="npm run build"
alias prd="pnpm dev"
alias prb="pnpm build"
alias w="wrangler"
alias wd="wrangler dev"
alias wp="wrangler deploy"

# Java / Maven / Vaadin
alias mci="mvn clean install"
alias mcist="mvn clean install -DskipTests"
alias msb="mvn spring-boot:run"
alias mj="sdk use java"

# Rede & Cibersegurança
alias ports="sudo netstat -tulpn | grep LISTEN"
alias myip="curl -s https://ifconfig.me/ip && echo"
alias localip="ip route get 1.2.3.4 | awk '{print \$7}'"
alias scan="sudo nmap -sC -sV"
alias sniff="sudo tshark -i any"

# Docker (quando habilitado)
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dstop="docker stop \$(docker ps -q)"
alias dclean="docker system prune -af --volumes"

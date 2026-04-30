#!/usr/bin/env bash
# ===========================================================================
# Kubera Installer v0.1.0
# Zero is better than negative.
# github.com/deepakachary/kubera
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash
#   bash install.sh [install|update|uninstall|logs|status]
# ===========================================================================

set -euo pipefail
IFS=$'\n\t'

# ─── Colours ────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  R="\033[0m" B="\033[1m" D="\033[2m"
  RED="\033[0;31m" GRN="\033[0;32m" YLW="\033[0;33m" CYN="\033[0;36m" WHT="\033[1;37m"
  AMB="\033[38;5;214m" BAMB="\033[1;38;5;214m"
  BGRN="\033[1;32m" BRED="\033[1;31m" BYLW="\033[1;33m"
else
  R="" B="" D="" RED="" GRN="" YLW="" CYN="" WHT="" AMB="" BAMB="" BGRN="" BRED="" BYLW=""
fi

# ─── Constants ──────────────────────────────────────────────────
KUBERA_REPO="https://raw.githubusercontent.com/sdachary/kubera/main"
KUBERA_IMAGE="ghcr.io/we-promise/sure:stable"
LOG_FILE="/tmp/kubera-install-$$.log"

# ─── State ──────────────────────────────────────────────────────
KUBERA_DIR="${HOME}/kubera"
KUBERA_PORT="3000"
DC="docker compose"
AI_PROVIDER="" AI_BASE="" AI_KEY="" AI_MODEL=""
AI_SKIPPED=false
SECRET_KEY="" DB_PASS=""

# ─── Print helpers ──────────────────────────────────────────────
cls()   { printf "\033[2J\033[H"; }
info()  { printf "  ${CYN}›${R}  %s\n" "$*"; }
ok()    { printf "  ${BGRN}✓${R}  %s\n" "$*"; }
warn()  { printf "  ${BYLW}!${R}  %s\n" "$*"; }
err()   { printf "  ${BRED}✗${R}  %s\n" "$*" >&2; }
skip_msg() { printf "  ${D}↷  %s${R}\n" "$*"; }
hr()    { printf "  ${D}──────────────────────────────────────────────────${R}\n"; }
die()   { err "$*"; exit 1; }

banner() {
  cls
  printf "\n${BAMB}"
  printf '  ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ \n'
  printf '  ██║ ██╔╝██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗\n'
  printf '  █████╔╝ ██║   ██║██████╔╝█████╗  ██████╔╝███████║\n'
  printf '  ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██╔══██╗██╔══██║\n'
  printf '  ██║  ██╗╚██████╔╝██████╔╝███████╗██║  ██║██║  ██║\n'
  printf '  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝\n'
  printf "${R}"
  printf "  ${D}Zero is better than negative.${R}\n"
  printf "  ${D}Personal finance OS · Self-hosted · Open source${R}\n\n"
  hr; echo
}

step() { printf "\n  ${BAMB}[%s/%s]${R}  ${WHT}%s${R}\n\n" "$1" "$2" "$3"; }

spin() {
  local pid=$1 msg="$2" f=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${AMB}%s${R}  %s  " "${f[$i]}" "$msg"
    i=$(( (i+1)%10 )); sleep 0.1
  done
  printf "\r%-70s\r" " "
}

# ─── Input helpers ──────────────────────────────────────────────
ensure_tty() {
  [[ -t 0 ]] || exec < /dev/tty || die "Cannot open TTY. Try: bash <(curl -fsSL ${KUBERA_REPO}/install.sh)"
}

ask() {
  local prompt=$1 var=$2 default=${3:-}
  local hint=""; [[ -n $default ]] && hint=" ${D}[${default}]${R}"
  printf "  ${BAMB}?${R}  ${WHT}%s${R}%s\n  ${D}›${R} " "$prompt" "$hint"
  local v; read -r v < /dev/tty
  [[ -z $v && -n $default ]] && v="$default"
  printf -v "$var" '%s' "$v"
}

ask_secret() {
  printf "  ${BAMB}?${R}  ${WHT}%s${R}\n  ${D}›${R} " "$1"
  local v; read -rs v < /dev/tty; echo
  printf -v "$2" '%s' "$v"
}

confirm() {
  printf "  ${BAMB}?${R}  ${WHT}%s${R} ${D}(y/n)${R}  ${D}›${R} " "$1"
  local a; read -r a < /dev/tty; [[ $a =~ ^[Yy]$ ]]
}

menu() {
  local prompt=$1; shift; local opts=("$@")
  printf "  ${BAMB}?${R}  ${WHT}%s${R}\n\n" "$prompt"
  for i in "${!opts[@]}"; do printf "    ${BAMB}%d)${R}  %s\n" "$((i+1))" "${opts[$i]}"; done
  echo
  local c
  while true; do
    printf "  ${D}[1–%d]${R}  ${D}›${R} " "${#opts[@]}"
    read -r c < /dev/tty
    [[ $c =~ ^[0-9]+$ ]] && (( c>=1 && c<=${#opts[@]} )) && { MENU_RESULT=$c; return; }
    warn "Enter a number between 1 and ${#opts[@]}"
  done
}

# ─── Helpers ────────────────────────────────────────────────────
has()   { command -v "$1" &>/dev/null; }
logcmd(){ "$@" >> "$LOG_FILE" 2>&1; }

gen_secret() {
  has openssl && { openssl rand -hex 64; return; }
  head -c 64 /dev/urandom | od -An -tx1 | tr -d ' \n'; echo
}

gen_pass() {
  has openssl && { openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32; return; }
  head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n' | head -c 32; echo
}

port_free() {
  local p=$1
  has lsof    && { lsof -iTCP:"$p" -sTCP:LISTEN &>/dev/null && return 1 || return 0; }
  has ss      && { ss -tlnH "sport = :$p" 2>/dev/null | grep -q . && return 1 || return 0; }
  has netstat && { netstat -tlnp 2>/dev/null | grep -q ":${p} " && return 1 || return 0; }
  (echo >/dev/tcp/127.0.0.1/"$p") &>/dev/null && return 1 || return 0
}

find_free() {
  local base=$1 found=()
  for p in $base 8080 8090 4000 4040 5000 9000 3001 3002; do
    port_free "$p" && found+=("$p")
    (( ${#found[@]} >= 4 )) && break
  done
  echo "${found[@]}"
}

resolve_dc() {
  docker compose version &>/dev/null 2>&1 && { DC="docker compose"; return 0; }
  has docker-compose                       && { DC="docker-compose"; return 0; }
  return 1
}

docker_ok() {
  has docker && docker info &>/dev/null 2>&1
}

suggest_docker() {
  case "$(uname -s)" in
    Darwin) echo "Install Docker Desktop: https://docs.docker.com/desktop/mac/install/" ;;
    Linux)
      has apt-get && echo "curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker \$USER" && return
      echo "https://docs.docker.com/engine/install/"
      ;;
    *) echo "https://docs.docker.com/engine/install/" ;;
  esac
}

# ════════════════════════════════════════════════════════════════
# INSTALL STEPS
# ════════════════════════════════════════════════════════════════

s1_deps() {
  banner; step 1 6 "Checking dependencies"

  # Docker
  if docker_ok; then
    ok "Docker $(docker version --format '{{.Server.Version}}' 2>/dev/null)"
  elif has docker; then
    warn "Docker installed but daemon is not running."
    info "Start Docker Desktop, or on Linux: sudo systemctl start docker"
    if confirm "Try to start Docker daemon now?"; then
      sudo systemctl start docker >> "$LOG_FILE" 2>&1 || true; sleep 2
      docker_ok || die "Docker daemon failed to start. Please start it manually and re-run."
      ok "Docker daemon started."
    else
      die "Docker daemon must be running. Start it and re-run the installer."
    fi
  else
    warn "Docker is not installed."
    local cmd; cmd=$(suggest_docker)
    echo; info "Install command:"; printf "    ${D}%s${R}\n\n" "$cmd"
    if confirm "Attempt automatic install now?"; then
      if [[ $cmd == http* ]]; then info "Visit the URL above, then re-run."; exit 1; fi
      eval "$cmd" >> "$LOG_FILE" 2>&1 & spin $! "Installing Docker..."
      ok "Docker installed. You may need to log out and back in."
    else
      die "Install Docker from https://docs.docker.com/engine/install/ then re-run."
    fi
  fi

  # Compose
  if resolve_dc; then
    ok "Docker Compose (${DC})"
  else
    warn "Docker Compose not found."
    if has apt-get; then
      info "Installing compose plugin..."
      sudo apt-get install -y docker-compose-plugin >> "$LOG_FILE" 2>&1 & spin $! "Installing..."
      resolve_dc && ok "Installed." || die "Install failed. See: https://docs.docker.com/compose/install/"
    else
      die "Install Docker Compose: https://docs.docker.com/compose/install/"
    fi
  fi

  # curl
  has curl && ok "curl" || die "curl required. Install: apt install curl / brew install curl"

  # openssl (soft)
  has openssl && ok "openssl" || warn "openssl not found — using /dev/urandom fallback (still secure)"

  echo; ok "All dependencies satisfied."; sleep 0.8
}

s2_port() {
  banner; step 2 6 "Port selection"

  info "Checking port 3000..."; echo
  if port_free 3000; then
    ok "Port 3000 is free."
    if confirm "Use port 3000?"; then KUBERA_PORT=3000; return; fi
  else
    warn "Port 3000 is already in use."
  fi

  info "Scanning for free ports..."; echo
  local ports_str; ports_str=$(find_free 3000)
  read -ra FREE <<< "$ports_str"

  local opts=()
  for p in "${FREE[@]}"; do opts+=("${p}  ${D}(available)${R}"); done
  opts+=("Enter a custom port")
  menu "Choose a port for Kubera:" "${opts[@]}"

  if (( MENU_RESULT <= ${#FREE[@]} )); then
    KUBERA_PORT="${FREE[$((MENU_RESULT-1))]}"
  else
    while true; do
      ask "Enter port number (1024–65535)" KUBERA_PORT "8080"
      [[ $KUBERA_PORT =~ ^[0-9]+$ ]] && (( KUBERA_PORT>=1024 && KUBERA_PORT<=65535 )) || { warn "Invalid port."; continue; }
      port_free "$KUBERA_PORT" && break || warn "Port ${KUBERA_PORT} is in use. Try another."
    done
  fi

  ok "Kubera will run on port ${KUBERA_PORT}"; sleep 0.5
}

s3_ai() {
  banner; step 3 6 "AI assistant setup"

  printf "  Kubera's AI helps you:\n\n"
  printf "    ${D}·${R}  Know which loan to pay off first\n"
  printf "    ${D}·${R}  Pick dividend stocks for SIP targets\n"
  printf "    ${D}·${R}  Suggest monthly rebalancing\n"
  printf "    ${D}·${R}  Track progress toward financial freedom\n\n"
  printf "  ${D}You can skip this and configure it later in Settings.${R}\n\n"

  if ! confirm "Configure AI assistant now?"; then
    skip_msg "Skipped — Settings → AI Assistant to configure later"
    AI_SKIPPED=true; sleep 0.5; return
  fi

  echo
  menu "Choose your AI provider:" \
    "OpenRouter       ${D}— 100+ models, free tier available (recommended)${R}" \
    "Ollama           ${D}— fully local, no API key needed${R}" \
    "Anthropic        ${D}— Claude models directly${R}" \
    "OpenAI           ${D}— GPT-4o, GPT-4o mini${R}" \
    "Custom endpoint  ${D}— any OpenAI-compatible API${R}" \
    "Skip for now"

  local c=$MENU_RESULT; echo

  case $c in
    1)
      AI_PROVIDER="openrouter"; AI_BASE="https://openrouter.ai/api/v1"
      printf "  ${D}Free key: ${R}${CYN}https://openrouter.ai/keys${R}\n"
      printf "  ${D}Free models: Llama 3.1 70B, Gemma 2, Mistral and more.${R}\n\n"
      ask_secret "Paste OpenRouter API key (sk-or-...)" AI_KEY; echo
      menu "Choose default model:" \
        "meta-llama/llama-3.1-70b-instruct  ${D}← free, great for finance${R}" \
        "google/gemma-2-9b-it               ${D}← free, fast${R}" \
        "mistralai/mistral-7b-instruct      ${D}← free, lightweight${R}" \
        "anthropic/claude-3.5-sonnet        ${D}← paid, best quality${R}" \
        "openai/gpt-4o-mini                 ${D}← paid, good balance${R}"
      local ms=("meta-llama/llama-3.1-70b-instruct" "google/gemma-2-9b-it" "mistralai/mistral-7b-instruct" "anthropic/claude-3.5-sonnet" "openai/gpt-4o-mini")
      AI_MODEL="${ms[$((MENU_RESULT-1))]}"
      ;;
    2)
      AI_PROVIDER="ollama"; AI_BASE="http://host.docker.internal:11434/v1"; AI_KEY="ollama"
      if ! has ollama; then
        warn "Ollama not installed."
        printf "  ${D}Install: ${R}${CYN}https://ollama.com/download${R}\n"
        printf "  ${D}Then run: ollama pull llama3.1${R}\n\n"
        skip_msg "Continuing — install Ollama before using AI features."
      else ok "Ollama found."; fi
      ask "Model name" AI_MODEL "llama3.1"
      ;;
    3)
      AI_PROVIDER="anthropic"; AI_BASE="https://api.anthropic.com/v1"
      printf "  ${D}Key: ${R}${CYN}https://console.anthropic.com${R}\n\n"
      ask_secret "Paste Anthropic API key (sk-ant-...)" AI_KEY; echo
      menu "Choose model:" "claude-3-5-sonnet-20241022  ${D}← best${R}" "claude-3-haiku-20240307  ${D}← fast, cheap${R}"
      local am=("claude-3-5-sonnet-20241022" "claude-3-haiku-20240307")
      AI_MODEL="${am[$((MENU_RESULT-1))]}"
      ;;
    4)
      AI_PROVIDER="openai"; AI_BASE="https://api.openai.com/v1"
      printf "  ${D}Key: ${R}${CYN}https://platform.openai.com/api-keys${R}\n\n"
      ask_secret "Paste OpenAI API key (sk-...)" AI_KEY; echo
      menu "Choose model:" "gpt-4o-mini  ${D}← recommended${R}" "gpt-4o  ${D}← best quality${R}"
      local om=("gpt-4o-mini" "gpt-4o"); AI_MODEL="${om[$((MENU_RESULT-1))]}"
      ;;
    5)
      AI_PROVIDER="custom"
      ask "API base URL (e.g. https://your-server/v1)" AI_BASE ""
      ask_secret "API key (Enter to skip)" AI_KEY; [[ -z $AI_KEY ]] && AI_KEY="none"
      ask "Model name" AI_MODEL "gpt-4o"
      ;;
    6)
      skip_msg "Skipped — Settings → AI Assistant to configure later"
      AI_SKIPPED=true; sleep 0.5; return
      ;;
  esac

  echo; ok "AI: ${AI_PROVIDER} · ${AI_MODEL}"; sleep 0.5
}

s4_dir() {
  banner; step 4 6 "Installation directory"
  printf "  Kubera stores config and database files here.\n\n"
  ask "Installation directory" KUBERA_DIR "${HOME}/kubera"

  if [[ -d $KUBERA_DIR ]]; then
    if [[ -f "${KUBERA_DIR}/compose.yml" ]]; then
      warn "Existing Kubera installation detected at: ${KUBERA_DIR}"
      confirm "Re-configure it? (data preserved, config overwritten)" || \
        die "Aborted. Run 'bash install.sh update' to update instead."
      ok "Will overwrite config files only."
    else
      confirm "Directory exists. Use it anyway?" || { s4_dir; return; }
    fi
  else
    mkdir -p "$KUBERA_DIR" || die "Cannot create directory: ${KUBERA_DIR}"
    ok "Created: ${KUBERA_DIR}"
  fi
  sleep 0.5
}

s5_generate() {
  banner; step 5 6 "Generating configuration"

  info "Generating keys..."; SECRET_KEY=$(gen_secret); DB_PASS=$(gen_pass); ok "Keys generated."

  # .env
  info "Writing .env..."
  local ai_block
  if [[ $AI_SKIPPED == true ]]; then
    ai_block="# AI not configured — uncomment below to enable:
# OPENAI_URI_BASE=https://openrouter.ai/api/v1
# OPENAI_ACCESS_TOKEN=sk-or-your-key
# OPENAI_MODEL=meta-llama/llama-3.1-70b-instruct"
  else
    ai_block="OPENAI_URI_BASE=${AI_BASE}
OPENAI_ACCESS_TOKEN=${AI_KEY}
OPENAI_MODEL=${AI_MODEL}"
  fi

  cat > "${KUBERA_DIR}/.env" << ENV
# Kubera .env — generated $(date)
# Restart after editing: cd ${KUBERA_DIR} && ${DC} restart

SELF_HOSTED=true
ONBOARDING_STATE=open
SECRET_KEY_BASE=${SECRET_KEY}

POSTGRES_USER=kubera_user
POSTGRES_PASSWORD=${DB_PASS}
POSTGRES_DB=kubera_production
DB_HOST=db
DB_PORT=5432

PORT=${KUBERA_PORT}
REDIS_URL=redis://redis:6379/1

RAILS_FORCE_SSL=false
RAILS_ASSUME_SSL=false

PRODUCT_NAME=Kubera
BRAND_NAME=Kubera

EXCHANGE_RATE_PROVIDER=yahoo_finance
SECURITIES_PROVIDER=yahoo_finance

${ai_block}
ENV
  chmod 600 "${KUBERA_DIR}/.env"
  ok ".env written (permissions: 600)."

  # compose.yml
  info "Writing compose.yml..."
  cat > "${KUBERA_DIR}/compose.yml" << COMPOSE
# Kubera compose.yml — generated $(date)
name: kubera

x-db: &db
  POSTGRES_USER: \${POSTGRES_USER:-kubera_user}
  POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
  POSTGRES_DB: \${POSTGRES_DB:-kubera_production}

x-app: &app
  <<: *db
  SECRET_KEY_BASE: \${SECRET_KEY_BASE}
  SELF_HOSTED: "true"
  RAILS_FORCE_SSL: "false"
  RAILS_ASSUME_SSL: \${RAILS_ASSUME_SSL:-false}
  DB_HOST: db
  DB_PORT: "5432"
  REDIS_URL: redis://redis:6379/1
  PORT: \${PORT:-3000}
  ONBOARDING_STATE: \${ONBOARDING_STATE:-open}
  OPENAI_URI_BASE: \${OPENAI_URI_BASE:-}
  OPENAI_ACCESS_TOKEN: \${OPENAI_ACCESS_TOKEN:-}
  OPENAI_MODEL: \${OPENAI_MODEL:-}
  EXCHANGE_RATE_PROVIDER: \${EXCHANGE_RATE_PROVIDER:-yahoo_finance}
  SECURITIES_PROVIDER: \${SECURITIES_PROVIDER:-yahoo_finance}
  PRODUCT_NAME: \${PRODUCT_NAME:-Kubera}
  BRAND_NAME: \${BRAND_NAME:-Kubera}

services:
  web:
    image: ${KUBERA_IMAGE}
    restart: unless-stopped
    ports: ["\${PORT:-${KUBERA_PORT}}:3000"]
    env_file: .env
    environment: { <<: *app }
    volumes: [app-storage:/rails/storage]
    depends_on:
      db:    { condition: service_healthy }
      redis: { condition: service_healthy }
    dns: [8.8.8.8, 1.1.1.1]
    networks: [kubera_net]

  worker:
    image: ${KUBERA_IMAGE}
    command: bundle exec sidekiq
    restart: unless-stopped
    env_file: .env
    environment: { <<: *app }
    volumes: [app-storage:/rails/storage]
    depends_on:
      db:    { condition: service_healthy }
      redis: { condition: service_healthy }
    dns: [8.8.8.8, 1.1.1.1]
    networks: [kubera_net]

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment: { <<: *db }
    volumes: [postgres-data:/var/lib/postgresql/data]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U \${POSTGRES_USER:-kubera_user} -d \${POSTGRES_DB:-kubera_production}"]
      interval: 5s
      timeout: 5s
      retries: 10
    networks: [kubera_net]

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    volumes: [redis-data:/data]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks: [kubera_net]

volumes:
  app-storage:
  postgres-data:
  redis-data:

networks:
  kubera_net:
    driver: bridge
COMPOSE
  ok "compose.yml written."
  sleep 0.5
}

s6_launch() {
  banner; step 6 6 "Pulling image and starting Kubera"
  cd "$KUBERA_DIR"

  info "Pulling ${KUBERA_IMAGE} (first run ~500MB)..."
  $DC pull >> "$LOG_FILE" 2>&1 & spin $! "Downloading image..."
  ok "Image pulled."

  info "Starting containers..."
  $DC up -d >> "$LOG_FILE" 2>&1 & spin $! "Starting web, worker, db, redis..."
  ok "Containers started."

  info "Waiting for app to be ready..."
  local w=0 ready=false
  while (( w < 90 )); do
    curl -sf "http://localhost:${KUBERA_PORT}/up" &>/dev/null && { ready=true; break; }
    printf "\r  ${D}›  Starting... %ds${R}   " "$w"
    sleep 3; (( w+=3 ))
  done
  printf "\r%-70s\r" " "
  $ready && ok "Kubera is ready!" || warn "Taking longer than expected — check logs: ${DC} logs -f web"
}

print_summary() {
  banner
  printf "  ${BGRN}Installation complete!${R}\n\n"; hr; echo
  printf "  ${WHT}Open Kubera${R}\n"
  printf "    ${BAMB}http://localhost:${KUBERA_PORT}${R}\n"
  printf "    ${D}Create your account on the first visit.${R}\n\n"
  printf "  ${WHT}Directory${R}\n    ${D}${KUBERA_DIR}${R}\n\n"
  printf "  ${WHT}AI assistant${R}\n"
  [[ $AI_SKIPPED == true ]] && printf "    ${D}Not configured — Settings → AI Assistant${R}\n\n" \
                             || printf "    ${GRN}✓${R}  ${AI_PROVIDER} · ${AI_MODEL}\n\n"
  printf "  ${WHT}Install log${R}\n    ${D}${LOG_FILE}${R}\n\n"
  hr; echo
  printf "  ${WHT}Useful commands${R}\n\n"
  printf "    ${D}Stop:${R}    cd %s && %s down\n"         "$KUBERA_DIR" "$DC"
  printf "    ${D}Start:${R}   cd %s && %s up -d\n"        "$KUBERA_DIR" "$DC"
  printf "    ${D}Update:${R}  curl -fsSL %s/install.sh | bash -s update\n" "$KUBERA_REPO"
  printf "    ${D}Logs:${R}    cd %s && %s logs -f web\n\n" "$KUBERA_DIR" "$DC"
  hr; echo
  printf "  ${BAMB}Zero is better than negative. Let's get you there.${R}\n\n"
}

# ════════════════════════════════════════════════════════════════
# SUBCOMMANDS
# ════════════════════════════════════════════════════════════════

cmd_update() {
  banner; ensure_tty
  local dir="${1:-${HOME}/kubera}"
  [[ -f "${dir}/compose.yml" ]] || die "No installation found at ${dir}"
  cd "$dir"; resolve_dc
  step 1 2 "Pulling latest image"
  $DC pull >> "$LOG_FILE" 2>&1 & spin $! "Downloading..."; ok "Updated."
  step 2 2 "Restarting services"
  $DC up --no-deps -d web worker >> "$LOG_FILE" 2>&1 & spin $! "Restarting..."; ok "Restarted."
  local port; port=$(grep "^PORT=" "${dir}/.env" 2>/dev/null | cut -d= -f2 || echo 3000)
  echo; printf "  ${BAMB}http://localhost:${port}${R}\n\n"
}

cmd_uninstall() {
  banner; ensure_tty
  local dir="${1:-${HOME}/kubera}"
  printf "  ${BRED}Uninstall Kubera${R}\n\n"
  warn "This will permanently delete all containers, volumes, and data in:"; printf "    ${D}${dir}${R}\n\n"
  confirm "Are you sure?" || { skip_msg "Cancelled."; exit 0; }
  confirm "Last chance — delete everything?" || { skip_msg "Cancelled."; exit 0; }
  if [[ -f "${dir}/compose.yml" ]]; then
    cd "$dir"; resolve_dc
    $DC down -v >> "$LOG_FILE" 2>&1 & spin $! "Removing containers and volumes..."; ok "Removed."
  fi
  rm -rf "$dir"; ok "Directory removed: ${dir}"
  echo; printf "  ${D}Kubera uninstalled.${R}\n\n"
}

cmd_logs() {
  local dir="${1:-${HOME}/kubera}"
  [[ -f "${dir}/compose.yml" ]] || die "No installation at ${dir}"
  cd "$dir"; resolve_dc; $DC logs -f web
}

cmd_status() {
  local dir="${1:-${HOME}/kubera}"
  [[ -f "${dir}/compose.yml" ]] || die "No installation at ${dir}"
  cd "$dir"; resolve_dc; $DC ps
}

# ════════════════════════════════════════════════════════════════
# MAIN
# ════════════════════════════════════════════════════════════════

main() {
  local cmd="${1:-install}"
  case "$cmd" in
    update|upgrade)   cmd_update   "${2:-}"; exit 0 ;;
    uninstall|remove) cmd_uninstall "${2:-}"; exit 0 ;;
    logs)             cmd_logs     "${2:-}"; exit 0 ;;
    status)           cmd_status   "${2:-}"; exit 0 ;;
    install|*)        : ;;
  esac

  ensure_tty; banner

  printf "  This installer sets up Kubera in about 3–5 minutes.\n\n"
  printf "    ${D}1.${R}  Check dependencies\n"
  printf "    ${D}2.${R}  Choose a port\n"
  printf "    ${D}3.${R}  Configure AI assistant\n"
  printf "    ${D}4.${R}  Choose install directory\n"
  printf "    ${D}5.${R}  Generate config files\n"
  printf "    ${D}6.${R}  Pull Docker image and launch\n\n"
  printf "  ${D}Install log: ${LOG_FILE}${R}\n\n"

  confirm "Ready to begin?" || { printf "\n  ${D}Cancelled.${R}\n\n"; exit 0; }

  s1_deps
  s2_port
  s3_ai
  s4_dir
  s5_generate
  s6_launch
  print_summary
}

main "$@"

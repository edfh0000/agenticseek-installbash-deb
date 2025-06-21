#!/bin/bash

# =================================================================================================
#
#    INSTALADOR Y GESTOR AVANZADO DE AGENTICSEEK (v12.2 - Final y Completo)
#
# Este script comprueba si la aplicación ya está instalada.
# - Si no lo está, ejecuta un asistente de instalación interactivo.
# - Si ya lo está, muestra un menú para gestionar los servicios (iniciar, detener, etc.).
#
# CÓMO USAR:
# 1. Guarda el archivo (p.ej., setup.sh).
# 2. Ejecútalo con: sudo bash setup.sh
# 3. Sigue las instrucciones en pantalla.
#
# =================================================================================================

# --- CONFIGURACIÓN INICIAL ---
set -e
REPO_DIR="/home/$(logname)/agenticSeek"
FLAG_FILE="$REPO_DIR/.installation_complete"

# --- FUNCIONES DE IDIOMA Y TEXTOS ---
setup_language() {
    clear
    echo "================================================="
    echo "  AgenticSeek Installer & Manager"
    echo "================================================="
    echo ""
    echo "Please select your language / Por favor, selecciona tu idioma:"
    echo "  1) English"
    echo "  2) Español"
    echo ""
    read -p "Enter your choice (1-2): " lang_choice

    if [[ "$lang_choice" == "2" ]]; then
        # Textos en Español
        MGM_TITLE="Gestor de AgenticSeek"; MGM_STATUS_CHECK="Comprobando estado de los servicios..."; MGM_WEB_URL="URL de Acceso"; MGM_OPT_1="1) Iniciar / Reiniciar Servicios"; MGM_OPT_2="2) Detener Servicios"; MGM_OPT_3="3) Ver Logs (En tiempo real, Ctrl+C para salir)"; MGM_OPT_4="4) Reinstalar (¡BORRARÁ TODO!)"; MGM_OPT_5="5) Salir"; MGM_PROMPT_CHOICE="Elige una opción"; MGM_STARTING_SERVICES="Iniciando/Reiniciando servicios..."; MGM_STOPPING_SERVICES="Deteniendo servicios..."; MGM_SHOWING_LOGS="Mostrando logs... Presiona Ctrl+C para volver al menú."; MGM_REINSTALL_CONFIRM="¿ESTÁS SEGURO? Esto borrará todo y empezará de nuevo. (S/n): "; MGM_REINSTALLING="Reinstalando..."; MGM_RESTARTING_SCRIPT="Reiniciando script de instalación..."; MGM_REINSTALL_CANCELLED="Reinstalación cancelada."; MGM_DONE="Hecho."; MGM_PRESS_ENTER="Presiona Enter para continuar..."; MGM_INVALID_OPTION="Opción no válida."; MSG_CONFIG_CHOICE="Elige tu modo de instalación:"; MSG_CONFIG_FAST="1) Instalación Rápida (Usa valores por defecto recomendados)"; MSG_CONFIG_CUSTOM="2) Configuración Personalizada (Introduce tus propias claves y puertos)"; MSG_PROMPT_CHOICE="Introduce tu elección (1-2)"; CUSTOM_TITLE="Configuración Personalizada"; CUSTOM_PROMPT_FRONTEND_PORT="Puerto para el Frontend (Web)"; CUSTOM_PROMPT_BACKEND_PORT="Puerto para el Backend (API)"; CUSTOM_PROMPT_SEARXNG="Introduce la URL de tu instancia de SearXNG"; MSG_PROMPT_API_KEYS="Ahora, vamos a configurar las claves API. Presiona Enter para omitir y usar 'xxxxx'."; MSG_STARTING="🚀 Iniciando la instalación automatizada de AgenticSeek..."; MSG_STEP="Paso"; MSG_UPDATE="Actualizando sistema e instalando dependencias..."; MSG_DOCKER_INSTALL="Instalando Docker y Docker Compose..."; MSG_DOCKER_FOUND="Docker ya está instalado. Omitiendo."; MSG_COMPOSE_FOUND="Plugin Docker Compose ya está instalado. Omitiendo."; MSG_UFW="Configurando el firewall (UFW)..."; MSG_CLONE="Clonando/Verificando el repositorio de AgenticSeek..."; MSG_CLONE_INCOMPLETE="El repositorio está incompleto o corrupto. Limpiando y volviendo a clonar..."; MSG_CLONE_OK="El repositorio ya existe y parece completo. Omitiendo."; MSG_ENV="Creando el archivo de configuración .env..."; MSG_DOCKER_YML="Reemplazando docker-compose.yml con una versión corregida y funcional..."; MSG_DOCKER_CLEAN="Limpiando redes de Docker potencialmente conflictivas..."; MSG_DOCKER_BUILD="Construyendo/Reconstruyendo las imágenes de Docker (puede tardar un poco)..."; MSG_DOCKER_UP="Iniciando todos los servicios..."; MSG_SUCCESS_TITLE="✅ ¡INSTALACIÓN COMPLETADA CON ÉXITO!"; MSG_SUCCESS_WEB="Accede a la interfaz web en:"; MSG_MANUAL_STEP_TITLE="⚠️ ¡ACCIÓN MANUAL REQUERIDA! ¡PASO FINAL Y CRUCIAL! ⚠️"; MSG_MANUAL_STEP_DESC="Si no puedes acceder a la web, es casi seguro que necesitas abrir los puertos en el firewall de GOOGLE CLOUD."; MSG_MANUAL_STEP_1="1. Ve a la consola de Google Cloud -> Red de VPC -> Firewall."; MSG_MANUAL_STEP_2="2. Crea DOS reglas de firewall de ENTRADA para '0.0.0.0/0':"; MSG_MANUAL_STEP_3="   - Una para el puerto del Frontend"; MSG_MANUAL_STEP_4="   - Otra para el puerto del Backend";
    else
        # Textos en Inglés (Default)
        MGM_TITLE="AgenticSeek Manager"; MGM_STATUS_CHECK="Checking services status..."; MGM_WEB_URL="Access URL"; MGM_OPT_1="1) Start / Restart Services"; MGM_OPT_2="2) Stop Services"; MGM_OPT_3="3) View Logs (Real-time, Ctrl+C to exit)"; MGM_OPT_4="4) Reinstall (WILL DELETE EVERYTHING!)"; MGM_OPT_5="5) Exit"; MGM_PROMPT_CHOICE="Choose an option"; MGM_STARTING_SERVICES="Starting/Restarting services..."; MGM_STOPPING_SERVICES="Stopping services..."; MGM_SHOWING_LOGS="Showing logs... Press Ctrl+C to return to the menu."; MGM_REINSTALL_CONFIRM="ARE YOU SURE? This will delete everything and start over. (y/N): "; MGM_REINSTALLING="Reinstalling..."; MGM_RESTARTING_SCRIPT="Restarting installation script..."; MGM_REINSTALL_CANCELLED="Reinstallation cancelled."; MGM_DONE="Done."; MGM_PRESS_ENTER="Press Enter to continue..."; MGM_INVALID_OPTION="Invalid option."; MSG_CONFIG_CHOICE="Choose your installation mode:"; MSG_CONFIG_FAST="1) Quick Install (Uses recommended defaults)"; MSG_CONFIG_CUSTOM="2) Custom Setup (Enter your own keys and ports)"; MSG_PROMPT_CHOICE="Enter your choice (1-2)"; CUSTOM_TITLE="Custom Setup"; CUSTOM_PROMPT_FRONTEND_PORT="Port for the Frontend (Web)"; CUSTOM_PROMPT_BACKEND_PORT="Port for the Backend (API)"; CUSTOM_PROMPT_SEARXNG="Enter the URL for your SearXNG instance"; MSG_PROMPT_API_KEYS="Now, let's set up the API keys. Press Enter to skip and use 'xxxxx'."; MSG_STARTING="🚀 Starting the automated AgenticSeek installation..."; MSG_STEP="Step"; MSG_UPDATE="Updating system and installing dependencies..."; MSG_DOCKER_INSTALL="Installing Docker and Docker Compose..."; MSG_DOCKER_FOUND="Docker is already installed. Skipping."; MSG_COMPOSE_FOUND="Docker Compose plugin is already installed. Skipping."; MSG_UFW="Configuring the firewall (UFW)..."; MSG_CLONE="Cloning/Verifying the AgenticSeek repository..."; MSG_CLONE_INCOMPLETE="Repository is incomplete or corrupt. Cleaning up and re-cloning..."; MSG_CLONE_OK="Repository already exists and seems complete. Skipping."; MSG_ENV="Creating the .env configuration file..."; MSG_DOCKER_YML="Replacing docker-compose.yml with a corrected and functional version..."; MSG_DOCKER_CLEAN="Cleaning up potentially conflicting Docker networks..."; MSG_DOCKER_BUILD="Building/Rebuilding Docker images (this may take a while)..."; MSG_DOCKER_UP="Starting all services..."; MSG_SUCCESS_TITLE="✅ INSTALLATION COMPLETED SUCCESSFULLY!"; MSG_SUCCESS_WEB="Access the web interface at:"; MSG_MANUAL_STEP_TITLE="⚠️ MANUAL ACTION REQUIRED! FINAL & CRUCIAL STEP! ⚠️"; MSG_MANUAL_STEP_DESC="If you cannot access the web UI, you almost certainly need to open the ports in the GOOGLE CLOUD firewall."; MSG_MANUAL_STEP_1="1. Go to Google Cloud Console -> VPC Network -> Firewall."; MSG_MANUAL_STEP_2="2. Create TWO INGRESS firewall rules for '0.0.0.0/0':"; MSG_MANUAL_STEP_3="   - One for the Frontend port"; MSG_MANUAL_STEP_4="   - Another for the Backend port";
    fi
}

# --- FUNCIÓN DEL MENÚ DE GESTIÓN ---
run_management_menu() {
    cd "$REPO_DIR"; PUBLIC_IP=$(curl -s -4 ifconfig.me || curl -s -4 icanhazip.com); source .env; FRONTEND_URL="http://${PUBLIC_IP}:${FRONTEND_PORT}"
    while true; do
        clear; echo "================================================="; echo "  $MGM_TITLE"; echo "================================================="
        echo "$MGM_STATUS_CHECK"; sudo docker compose ps; echo "-------------------------------------------------"; echo "$MGM_WEB_URL: $FRONTEND_URL"; echo "-------------------------------------------------"
        echo ""; echo "  $MGM_OPT_1"; echo "  $MGM_OPT_2"; echo "  $MGM_OPT_3"; echo "  $MGM_OPT_4"; echo "  $MGM_OPT_5"; echo ""
        read -p "$MGM_PROMPT_CHOICE: " mgm_choice
        case $mgm_choice in
            1) echo "$MGM_STARTING_SERVICES"; sudo docker compose up -d --force-recreate; echo "$MGM_DONE";;
            2) echo "$MGM_STOPPING_SERVICES"; sudo docker compose down; echo "$MGM_DONE";;
            3) echo "$MGM_SHOWING_LOGS"; sudo docker compose logs -f;;
            4) read -p "$MGM_REINSTALL_CONFIRM" confirm
                if [[ "$confirm" =~ ^[SsYy]$ ]]; then
                    echo "$MGM_REINSTALLING"; sudo docker compose down -v > /dev/null 2>&1 || true; rm -rf "$REPO_DIR"
                    echo "$MGM_RESTARTING_SCRIPT"; sudo bash "$0"; exit 0
                else echo "$MGM_REINSTALL_CANCELLED"; fi;;
            5) exit 0;;
            *) echo "$MGM_INVALID_OPTION";;
        esac
        read -p "$MGM_PRESS_ENTER"
    done
}

# --- FUNCIÓN DEL PROCESO DE INSTALACIÓN ---
run_installation() {
    clear; echo "================================================="; echo "  $MSG_CONFIG_CHOICE"; echo "================================================="
    echo "  $MSG_CONFIG_FAST"; echo "  $MSG_CONFIG_CUSTOM"; echo ""; read -p "$MSG_PROMPT_CHOICE [1]: " setup_choice

    FRONTEND_PORT=39899; BACKEND_PORT=7777; SEARXNG_BASE_URL="https://paulgo.io"
    OPENAI_API_KEY='xxxxx'; DEEPSEEK_API_KEY='xxxxx'; OPENROUTER_API_KEY='xxxxx'; TOGETHER_API_KEY='xxxxx';
    GOOGLE_API_KEY='xxxxx'; ANTHROPIC_API_KEY='xxxxx'; HUGGINGFACE_API_KEY='xxxxx'; DSK_DEEPSEEK_API_KEY='xxxxx';

    if [[ "$setup_choice" == "2" ]]; then
      clear; echo "================================================="; echo "  $CUSTOM_TITLE"; echo "================================================="; echo ""
      read -p "$CUSTOM_PROMPT_FRONTEND_PORT [39899]: " custom_frontend_port; FRONTEND_PORT=${custom_frontend_port:-39899}
      read -p "$CUSTOM_PROMPT_BACKEND_PORT [7777]: " custom_backend_port; BACKEND_PORT=${custom_backend_port:-7777}
      read -p "$CUSTOM_PROMPT_SEARXNG [https://paulgo.io]: " custom_searxng; SEARXNG_BASE_URL=${custom_searxng:-"https://paulgo.io"}
      echo ""; echo "$MSG_PROMPT_API_KEYS"; echo "-------------------------------------------------"
      read -p "OPENAI_API_KEY: " custom_openai; OPENAI_API_KEY=${custom_openai:-'xxxxx'}
      read -p "OPENROUTER_API_KEY: " custom_openrouter; OPENROUTER_API_KEY=${custom_openrouter:-'xxxxx'}
      read -p "TOGETHER_API_KEY: " custom_together; TOGETHER_API_KEY=${custom_together:-'xxxxx'}
      read -p "GOOGLE_API_KEY: " custom_google; GOOGLE_API_KEY=${custom_google:-'xxxxx'}
      read -p "DEEPSEEK_API_KEY: " custom_deepseek; DEEPSEEK_API_KEY=${custom_deepseek:-'xxxxx'}
      read -p "HUGGINGFACE_API_KEY: " custom_hf; HUGGINGFACE_API_KEY=${custom_hf:-'xxxxx'}
      read -p "ANTHROPIC_API_KEY: " custom_anthropic; ANTHROPIC_API_KEY=${custom_anthropic:-'xxxxx'}
      read -p "DSK_DEEPSEEK_API_KEY: " custom_dsk; DSK_DEEPSEEK_API_KEY=${custom_dsk:-'xxxxx'}
    fi

    clear; echo ""; echo "$MSG_STARTING"; echo ""
    PUBLIC_IP=$(curl -s -4 ifconfig.me || curl -s -4 icanhazip.com)

    echo "[$MSG_STEP 1/9] $MSG_UPDATE"; apt-get update > /dev/null 2>&1 && apt-get upgrade -y > /dev/null 2>&1 && apt-get install -y curl git ufw sudo nano > /dev/null 2>&1
    echo "[$MSG_STEP 2/9] $MSG_DOCKER_INSTALL"
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh; sh get-docker.sh > /dev/null 2>&1; rm get-docker.sh; usermod -aG docker $(logname)
    else echo "  - $MSG_DOCKER_FOUND"; fi
    if ! docker compose version &> /dev/null; then
        DOCKER_CONFIG_PATH="/home/$(logname)/.docker"; mkdir -p "$DOCKER_CONFIG_PATH/cli-plugins"
        curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o "$DOCKER_CONFIG_PATH/cli-plugins/docker-compose" > /dev/null 2>&1
        chmod +x "$DOCKER_CONFIG_PATH/cli-plugins/docker-compose"
    else echo "  - $MSG_COMPOSE_FOUND"; fi

    echo "[$MSG_STEP 3/9] $MSG_UFW"; ufw allow 22/tcp > /dev/null; ufw allow $FRONTEND_PORT/tcp > /dev/null; ufw allow $BACKEND_PORT/tcp > /dev/null
    if ufw status | grep -q "Status: inactive"; then ufw --force enable > /dev/null; fi

    echo "[$MSG_STEP 4/9] $MSG_CLONE"; cd "/home/$(logname)"; if [ ! -f "$REPO_DIR/docker-compose.yml" ]; then
        echo "  - $MSG_CLONE_INCOMPLETE"; rm -rf "$REPO_DIR"; git config --system --unset-all credential.helper || true
        git clone https://github.com/Fosowl/agenticSeek.git > /dev/null 2>&1
    else echo "  - $MSG_CLONE_OK"; fi
    cd "$REPO_DIR"

    echo "[$MSG_STEP 5/9] $MSG_ENV"
    tee .env > /dev/null <<EOF
# Configuration generated by setup script
FRONTEND_PORT=${FRONTEND_PORT}
BACKEND_PORT=${BACKEND_PORT}
SEARXNG_BASE_URL="${SEARXNG_BASE_URL}"
REDIS_BASE_URL="redis://redis:6379/0"
WORK_DIR="/app"
OPENAI_API_KEY='${OPENAI_API_KEY}'
DEEPSEEK_API_KEY='${DEEPSEEK_API_KEY}'
OPENROUTER_API_KEY='${OPENROUTER_API_KEY}'
TOGETHER_API_KEY='${TOGETHER_API_KEY}'
GOOGLE_API_KEY='${GOOGLE_API_KEY}'
ANTHROPIC_API_KEY='${ANTHROPIC_API_KEY}'
HUGGINGFACE_API_KEY='${HUGGINGFACE_API_KEY}'
DSK_DEEPSEEK_API_KEY='${DSK_DEEPSEEK_API_KEY}'
EOF

    echo "[$MSG_STEP 6/9] $MSG_DOCKER_YML"
    tee docker-compose.yml > /dev/null <<EOF
version: '3.8'
services:
  redis: {container_name: redis, image: docker.io/valkey/valkey:8-alpine, command: valkey-server --save 30 1 --loglevel warning, restart: unless-stopped, volumes: [- redis-data:/data], networks: [- agentic-seek-net]}
  frontend: {container_name: frontend, build: {context: ./frontend, dockerfile: Dockerfile.frontend}, ports: ["${FRONTEND_PORT}:3000"], environment: [- REACT_APP_BACKEND_URL=http://${PUBLIC_IP}:${BACKEND_PORT}], networks: [- agentic-seek-net], depends_on: [backend]}
  backend: {container_name: backend, build: {context: ., dockerfile: Dockerfile.backend}, ports: ["\${BACKEND_PORT}:\${BACKEND_PORT}"], volumes: [- ./:/app], command: python3 api.py, environment: {SEARXNG_URL: \${SEARXNG_BASE_URL}, REDIS_URL: \${REDIS_BASE_URL}, WORK_DIR: /app, BACKEND_PORT: \${BACKEND_PORT}, OPENAI_API_KEY: \${OPENAI_API_KEY}, DEEPSEEK_API_KEY: \${DEEPSEEK_API_KEY}, OPENROUTER_API_KEY: \${OPENROUTER_API_KEY}, TOGETHER_API_KEY: \${TOGETHER_API_KEY}, GOOGLE_API_KEY: \${GOOGLE_API_KEY}, ANTHROPIC_API_KEY: \${ANTHROPIC_API_KEY}, HUGGINGFACE_API_KEY: \${HUGGINGFACE_API_KEY}, DSK_DEEPSEEK_API_KEY: \${DSK_DEEPSEEK_API_KEY}}, depends_on: [redis], networks: [- agentic-seek-net]}
volumes: {redis-data: {}}
networks: {agentic-seek-net: {driver: bridge}}
EOF

    echo "[$MSG_STEP 7/9] $MSG_DOCKER_CLEAN"; docker compose down > /dev/null 2>&1 || true; docker network prune -f > /dev/null 2>&1
    echo "[$MSG_STEP 8/9] $MSG_DOCKER_BUILD"; docker compose build --no-cache
    echo "[$MSG_STEP 9/9] $MSG_DOCKER_UP"; docker compose up -d
    
    touch "$FLAG_FILE"

    echo ""; echo "=========================================================================="; echo "  $MSG_SUCCESS_TITLE"; echo "=========================================================================="
    echo ""; echo "  $MSG_SUCCESS_WEB"; echo "  🌐 http://${PUBLIC_IP}:${FRONTEND_PORT}"
    echo ""; echo "--------------------------------------------------------------------------"; echo "  $MSG_MANUAL_STEP_TITLE"; echo "--------------------------------------------------------------------------"
    echo "  $MSG_MANUAL_STEP_DESC"; echo "  $MSG_MANUAL_STEP_1"; echo "  $MSG_MANUAL_STEP_2"
    echo "  $MSG_MANUAL_STEP_3 (tcp:${FRONTEND_PORT})"; echo "  $MSG_MANUAL_STEP_4 (tcp:${BACKEND_PORT})"
    echo "--------------------------------------------------------------------------"
}

# --- LÓGICA PRINCIPAL DEL SCRIPT ---
setup_language
if [ -f "$FLAG_FILE" ]; then
    run_management_menu
else
    run_installation
fi

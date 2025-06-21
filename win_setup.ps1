# =================================================================================================
#
#    INSTALADOR Y GESTOR AVANZADO DE AGENTICSEEK para WINDOWS (v12.2-PS)
#
# Este script comprueba si la aplicación ya está instalada.
# - Si no lo está, ejecuta un asistente de instalación interactivo.
# - Si ya lo está, muestra un menú para gestionar los servicios.
#
# CÓMO USAR:
# 1. Instala los prerrequisitos: Docker Desktop y Git para Windows.
# 2. Guarda este archivo como `setup.ps1`.
# 3. Haz clic derecho en PowerShell y selecciona "Ejecutar como Administrador".
# 4. Ejecuta el script: .\setup.ps1
# 5. Sigue las instrucciones en pantalla.
#
# =================================================================================================

# --- CONFIGURACIÓN INICIAL ---
$RepoDir = "$env:USERPROFILE\agenticSeek"
$FlagFile = "$RepoDir\.installation_complete"

# --- FUNCIÓN DE IDIOMA Y TEXTOS ---
function Set-LanguageStrings {
    Clear-Host
    Write-Host "================================================="
    Write-Host "  AgenticSeek Installer & Manager for Windows"
    Write-Host "================================================="
    Write-Host ""
    Write-Host "Please select your language / Por favor, selecciona tu idioma:"
    Write-Host "  1) English"
    Write-Host "  2) Español"
    Write-Host ""
    $lang_choice = Read-Host "Enter your choice (1-2)"

    if ($lang_choice -eq "2") {
        # Textos en Español
        $script:lang = @{
            MGM_TITLE                 = "Gestor de AgenticSeek"
            MGM_STATUS_CHECK          = "Comprobando estado de los servicios..."
            MGM_WEB_URL               = "URL de Acceso"
            MGM_OPT_1                 = "1) Iniciar / Reiniciar Servicios"
            MGM_OPT_2                 = "2) Detener Servicios"
            MGM_OPT_3                 = "3) Ver Logs (En tiempo real, Ctrl+C para salir)"
            MGM_OPT_4                 = "4) Reinstalar (¡BORRARÁ TODO!)"
            MGM_OPT_5                 = "5) Salir"
            MGM_PROMPT_CHOICE         = "Elige una opción"
            MGM_STARTING_SERVICES     = "Iniciando/Reiniciando servicios..."
            MGM_STOPPING_SERVICES     = "Deteniendo servicios..."
            MGM_SHOWING_LOGS          = "Mostrando logs... Presiona Ctrl+C para volver al menú."
            MGM_REINSTALL_CONFIRM     = "¿ESTÁS SEGURO? Esto borrará todo y empezará de nuevo. (S/n): "
            MGM_REINSTALLING          = "Reinstalando..."
            MGM_RESTARTING_SCRIPT     = "Reiniciando script de instalación..."
            MGM_REINSTALL_CANCELLED   = "Reinstalación cancelada."
            MGM_DONE                  = "Hecho."
            MGM_PRESS_ENTER           = "Presiona Enter para continuar..."
            MGM_INVALID_OPTION        = "Opción no válida."
            MSG_CONFIG_CHOICE         = "Elige tu modo de instalación:"
            MSG_CONFIG_FAST           = "1) Instalación Rápida (Usa valores por defecto recomendados)"
            MSG_CONFIG_CUSTOM         = "2) Configuración Personalizada (Introduce tus propias claves y puertos)"
            MSG_PROMPT_CHOICE         = "Introduce tu elección (1-2)"
            CUSTOM_TITLE              = "Configuración Personalizada"
            CUSTOM_PROMPT_FRONTEND_PORT = "Puerto para el Frontend (Web)"
            CUSTOM_PROMPT_BACKEND_PORT  = "Puerto para el Backend (API)"
            CUSTOM_PROMPT_SEARXNG     = "Introduce la URL de tu instancia de SearXNG"
            MSG_PROMPT_API_KEYS       = "Ahora, vamos a configurar las claves API. Presiona Enter para omitir y usar 'xxxxx'."
            MSG_STARTING              = "🚀 Iniciando la instalación automatizada de AgenticSeek..."
            MSG_STEP                  = "Paso"
            MSG_PREREQ_CHECK          = "Comprobando prerrequisitos (Docker y Git)..."
            MSG_DOCKER_FAIL           = "ERROR: Docker no se ha encontrado. Por favor, instala Docker Desktop y asegúrate de que se está ejecutando."
            MSG_GIT_FAIL              = "ERROR: Git no se ha encontrado. Por favor, instala Git para Windows desde git-scm.com."
            MSG_FIREWALL              = "Configurando el Firewall de Windows..."
            MSG_CLONE                 = "Clonando/Verificando el repositorio de AgenticSeek..."
            MSG_CLONE_INCOMPLETE      = "El repositorio está incompleto o corrupto. Limpiando y volviendo a clonar..."
            MSG_CLONE_OK              = "El repositorio ya existe y parece completo. Omitiendo."
            MSG_ENV                   = "Creando el archivo de configuración .env..."
            MSG_DOCKER_YML            = "Creando el archivo docker-compose.yml con la configuración corregida..."
            MSG_DOCKER_BUILD          = "Construyendo/Reconstruyendo las imágenes de Docker (puede tardar un poco)..."
            MSG_DOCKER_UP             = "Iniciando todos los servicios..."
            MSG_SUCCESS_TITLE         = "✅ ¡INSTALACIÓN COMPLETADA CON ÉXITO!"
            MSG_SUCCESS_WEB           = "Accede a la interfaz web en:"
        }
    } else {
        # Textos en Inglés (Default)
        $script:lang = @{
            MGM_TITLE                 = "AgenticSeek Manager"
            MGM_STATUS_CHECK          = "Checking services status..."
            MGM_WEB_URL               = "Access URL"
            MGM_OPT_1                 = "1) Start / Restart Services"
            MGM_OPT_2                 = "2) Stop Services"
            MGM_OPT_3                 = "3) View Logs (Real-time, Ctrl+C to exit)"
            MGM_OPT_4                 = "4) Reinstall (WILL DELETE EVERYTHING!)"
            MGM_OPT_5                 = "5) Exit"
            MGM_PROMPT_CHOICE         = "Choose an option"
            MGM_STARTING_SERVICES     = "Starting/Restarting services..."
            MGM_STOPPING_SERVICES     = "Stopping services..."
            MGM_SHOWING_LOGS          = "Showing logs... Press Ctrl+C to return to the menu."
            MGM_REINSTALL_CONFIRM     = "ARE YOU SURE? This will delete everything and start over. (y/N): "
            MGM_REINSTALLING          = "Reinstalling..."
            MGM_RESTARTING_SCRIPT     = "Restarting installation script..."
            MGM_REINSTALL_CANCELLED   = "Reinstallation cancelled."
            MGM_DONE                  = "Done."
            MGM_PRESS_ENTER           = "Press Enter to continue..."
            MGM_INVALID_OPTION        = "Invalid option."
            MSG_CONFIG_CHOICE         = "Choose your installation mode:"
            MSG_CONFIG_FAST           = "1) Quick Install (Uses recommended defaults)"
            MSG_CONFIG_CUSTOM         = "2) Custom Setup (Enter your own keys and ports)"
            MSG_PROMPT_CHOICE         = "Enter your choice (1-2)"
            CUSTOM_TITLE              = "Custom Setup"
            CUSTOM_PROMPT_FRONTEND_PORT = "Port for the Frontend (Web)"
            CUSTOM_PROMPT_BACKEND_PORT  = "Port for the Backend (API)"
            CUSTOM_PROMPT_SEARXNG     = "Enter the URL for your SearXNG instance"
            MSG_PROMPT_API_KEYS       = "Now, let's set up the API keys. Press Enter to skip and use 'xxxxx'."
            MSG_STARTING              = "🚀 Starting the automated AgenticSeek installation..."
            MSG_STEP                  = "Step"
            MSG_PREREQ_CHECK          = "Checking for prerequisites (Docker and Git)..."
            MSG_DOCKER_FAIL           = "ERROR: Docker was not found. Please install Docker Desktop and make sure it is running."
            MSG_GIT_FAIL              = "ERROR: Git was not found. Please install Git for Windows from git-scm.com."
            MSG_FIREWALL              = "Configuring Windows Firewall..."
            MSG_CLONE                 = "Cloning/Verifying the AgenticSeek repository..."
            MSG_CLONE_INCOMPLETE      = "Repository is incomplete or corrupt. Cleaning up and re-cloning..."
            MSG_CLONE_OK              = "Repository already exists and seems complete. Skipping."
            MSG_ENV                   = "Creating the .env configuration file..."
            MSG_DOCKER_YML            = "Creating docker-compose.yml file with the corrected configuration..."
            MSG_DOCKER_BUILD          = "Building/Rebuilding Docker images (this may take a while)..."
            MSG_DOCKER_UP             = "Starting all services..."
            MSG_SUCCESS_TITLE         = "✅ INSTALLATION COMPLETED SUCCESSFULLY!"
            MSG_SUCCESS_WEB           = "Access the web interface at:"
        }
    }
}

# --- FUNCIÓN DEL MENÚ DE GESTIÓN ---
function Show-ManagementMenu {
    Set-Location $RepoDir # Asegurarse de estar en el directorio correcto
    
    # Leer los puertos desde el .env para mostrarlos
    $envContent = Get-Content .\.env | Out-String
    $envConfig = ConvertFrom-StringData -StringData $envContent
    $FrontendPort = $envConfig.FRONTEND_PORT
    $FrontendUrl = "http://localhost:$FrontendPort"

    while ($true) {
        Clear-Host
        Write-Host "================================================="
        Write-Host "  $($lang.MGM_TITLE)"
        Write-Host "================================================="
        Write-Host "$($lang.MGM_STATUS_CHECK)"
        docker compose ps
        Write-Host "-------------------------------------------------"
        Write-Host "$($lang.MGM_WEB_URL): $FrontendUrl"
        Write-Host "-------------------------------------------------"
        Write-Host ""
        Write-Host "  $($lang.MGM_OPT_1)"
        Write-Host "  $($lang.MGM_OPT_2)"
        Write-Host "  $($lang.MGM_OPT_3)"
        Write-Host "  $($lang.MGM_OPT_4)"
        Write-Host "  $($lang.MGM_OPT_5)"
        Write-Host ""
        $mgm_choice = Read-Host "$($lang.MGM_PROMPT_CHOICE)"

        switch ($mgm_choice) {
            "1" { Write-Host "$($lang.MGM_STARTING_SERVICES)"; docker compose up -d --force-recreate; Write-Host "$($lang.MGM_DONE)" }
            "2" { Write-Host "$($lang.MGM_STOPPING_SERVICES)"; docker compose down; Write-Host "$($lang.MGM_DONE)" }
            "3" { Write-Host "$($lang.MGM_SHOWING_LOGS)"; docker compose logs -f }
            "4" { 
                $confirm = Read-Host "$($lang.MGM_REINSTALL_CONFIRM)"
                if ($confirm -eq 'S' -or $confirm -eq 's' -or $confirm -eq 'Y' -or $confirm -eq 'y') {
                    Write-Host "$($lang.MGM_REINSTALLING)"
                    docker compose down -v 2>$null
                    Remove-Item -Path $RepoDir -Recurse -Force
                    Write-Host "$($lang.MGM_RESTARTING_SCRIPT)"
                    # Vuelve a ejecutar el script actual
                    & $PSCommandPath
                    exit
                } else {
                    Write-Host "$($lang.MGM_REINSTALL_CANCELLED)"
                }
            }
            "5" { exit }
            default { Write-Host "$($lang.MGM_INVALID_OPTION)" }
        }
        Read-Host "$($lang.MGM_PRESS_ENTER)"
    }
}

# --- FUNCIÓN DEL PROCESO DE INSTALACIÓN ---
function Start-Installation {
    Clear-Host
    Write-Host "================================================="
    Write-Host "  $($lang.MSG_CONFIG_CHOICE)"
    Write-Host "================================================="
    Write-Host "  $($lang.MSG_CONFIG_FAST)"
    Write-Host "  $($lang.MSG_CONFIG_CUSTOM)"
    Write-Host ""
    $setup_choice = Read-Host "$($lang.MSG_PROMPT_CHOICE) [1]"

    # Valores por defecto
    $FrontendPort = 39899
    $BackendPort = 7777
    $SearxngBaseUrl = "https://paulgo.io"
    $ApiKeys = @{
        OPENAI_API_KEY      = 'xxxxx'
        DEEPSEEK_API_KEY    = 'xxxxx'
        OPENROUTER_API_KEY  = 'xxxxx'
        TOGETHER_API_KEY    = 'xxxxx'
        GOOGLE_API_KEY      = 'xxxxx'
        ANTHROPIC_API_KEY   = 'xxxxx'
        HUGGINGFACE_API_KEY = 'xxxxx'
        DSK_DEEPSEEK_API_KEY= 'xxxxx'
    }

    if ($setup_choice -eq "2") {
      Clear-Host
      Write-Host "================================================="; Write-Host "  $($lang.CUSTOM_TITLE)"; Write-Host "================================================="; Write-Host ""
      $custom_frontend_port = Read-Host "$($lang.CUSTOM_PROMPT_FRONTEND_PORT) [39899]"; if ($custom_frontend_port) { $FrontendPort = $custom_frontend_port }
      $custom_backend_port = Read-Host "$($lang.CUSTOM_PROMPT_BACKEND_PORT) [7777]"; if ($custom_backend_port) { $BackendPort = $custom_backend_port }
      $custom_searxng = Read-Host "$($lang.CUSTOM_PROMPT_SEARXNG) [https://paulgo.io]"; if ($custom_searxng) { $SearxngBaseUrl = $custom_searxng }
      Write-Host ""; Write-Host "$($lang.MSG_PROMPT_API_KEYS)"; Write-Host "-------------------------------------------------"
      $ApiKeys.Keys | ForEach-Object {
          $keyName = $_
          $custom_key = Read-Host "$keyName"
          if ($custom_key) { $ApiKeys[$keyName] = $custom_key }
      }
    }

    Clear-Host; Write-Host ""; Write-Host "$($lang.MSG_STARTING)"; Write-Host ""

    Write-Host "[$($lang.MSG_STEP) 1/8] $($lang.MSG_PREREQ_CHECK)"
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { Write-Host "$($lang.MSG_DOCKER_FAIL)"; exit 1 }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host "$($lang.MSG_GIT_FAIL)"; exit 1 }

    Write-Host "[$($lang.MSG_STEP) 2/8] $($lang.MSG_FIREWALL)"
    $portsToAllow = @($FrontendPort, $BackendPort)
    foreach ($port in $portsToAllow) {
        $ruleName = "AgenticSeek-Port-$port"
        if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
            New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port | Out-Null
        }
    }

    Write-Host "[$($lang.MSG_STEP) 3/8] $($lang.MSG_CLONE)"
    Set-Location $env:USERPROFILE
    if (-not (Test-Path "$RepoDir\docker-compose.yml")) {
        Write-Host "  - $($lang.MSG_CLONE_INCOMPLETE)"
        if (Test-Path $RepoDir) { Remove-Item -Path $RepoDir -Recurse -Force }
        git clone https://github.com/Fosowl/agenticSeek.git $RepoDir
    } else {
        Write-Host "  - $($lang.MSG_CLONE_OK)"
    }
    Set-Location $RepoDir

    Write-Host "[$($lang.MSG_STEP) 4/8] $($lang.MSG_ENV)"
    $envContent = @"
# Configuration generated by setup script
FRONTEND_PORT=$FrontendPort
BACKEND_PORT=$BackendPort
SEARXNG_BASE_URL="$SearxngBaseUrl"
REDIS_BASE_URL="redis://redis:6379/0"
WORK_DIR="/app"
OPENAI_API_KEY='$($ApiKeys.OPENAI_API_KEY)'
DEEPSEEK_API_KEY='$($ApiKeys.DEEPSEEK_API_KEY)'
OPENROUTER_API_KEY='$($ApiKeys.OPENROUTER_API_KEY)'
TOGETHER_API_KEY='$($ApiKeys.TOGETHER_API_KEY)'
GOOGLE_API_KEY='$($ApiKeys.GOOGLE_API_KEY)'
ANTHROPIC_API_KEY='$($ApiKeys.ANTHROPIC_API_KEY)'
HUGGINGFACE_API_KEY='$($ApiKeys.HUGGINGFACE_API_KEY)'
DSK_DEEPSEEK_API_KEY='$($ApiKeys.DSK_DEEPSEEK_API_KEY)'
"@
    $envContent | Set-Content -Path .\.env

    Write-Host "[$($lang.MSG_STEP) 5/8] $($lang.MSG_DOCKER_YML)"
    # En Windows, host.docker.internal es la forma correcta para que los contenedores lleguen al host,
    # pero aquí el frontend (en el navegador) necesita la IP local. Usaremos localhost.
    $dockerComposeContent = @"
version: '3.8'
services:
  redis:
    container_name: redis
    image: docker.io/valkey/valkey:8-alpine
    command: valkey-server --save 30 1 --loglevel warning
    restart: unless-stopped
    volumes:
      - redis-data:/data
    networks:
      - agentic-seek-net
  frontend:
    container_name: frontend
    build:
      context: ./frontend
      dockerfile: Dockerfile.frontend
    ports:
      - "$FrontendPort:3000"
    environment:
      - REACT_APP_BACKEND_URL=http://localhost:$BackendPort
    networks:
      - agentic-seek-net
    depends_on:
      - backend
  backend:
    container_name: backend
    build:
      context: .
      dockerfile: Dockerfile.backend
    shm_size: '2gb'
    command: python3 api.py --no-sandbox --disable-dev-shm-usage
    ports:
      - "$BackendPort`:`$BackendPort"
    volumes:
      - ./:/app
    environment:
      SEARXNG_URL: `$env:SEARXNG_BASE_URL
      REDIS_URL: `$env:REDIS_BASE_URL
      WORK_DIR: /app
      BACKEND_PORT: `$env:BACKEND_PORT
      OPENAI_API_KEY: `$env:OPENAI_API_KEY
      DEEPSEEK_API_KEY: `$env:DEEPSEEK_API_KEY
      OPENROUTER_API_KEY: `$env:OPENROUTER_API_KEY
      TOGETHER_API_KEY: `$env:TOGETHER_API_KEY
      GOOGLE_API_KEY: `$env:GOOGLE_API_KEY
      ANTHROPIC_API_KEY: `$env:ANTHROPIC_API_KEY
      HUGGINGFACE_API_KEY: `$env:HUGGINGFACE_API_KEY
      DSK_DEEPSEEK_API_KEY: `$env:DSK_DEEPSEEK_API_KEY
    depends_on:
      - redis
    networks:
      - agentic-seek-net
volumes:
  redis-data: {}
networks:
  agentic-seek-net:
    driver: bridge
"@
    $dockerComposeContent | Set-Content -Path .\docker-compose.yml

    Write-Host "[$($lang.MSG_STEP) 6/8] $($lang.MSG_DOCKER_BUILD)"
    docker compose build --no-cache
    Write-Host "[$($lang.MSG_STEP) 7/8] $($lang.MSG_DOCKER_UP)"
    docker compose up -d
    
    New-Item -Path $FlagFile -ItemType File | Out-Null

    Write-Host ""
    Write-Host "=========================================================================="
    Write-Host "  $($lang.MSG_SUCCESS_TITLE)"
    Write-Host "=========================================================================="
    Write-Host ""
    Write-Host "  $($lang.MSG_SUCCESS_WEB)"
    Write-Host "  🌐 http://localhost:$FrontendPort"
    Write-Host ""
}

# --- LÓGICA PRINCIPAL DEL SCRIPT ---
Set-LanguageStrings
if (Test-Path $FlagFile) {
    Show-ManagementMenu
} else {
    Start-Installation
}

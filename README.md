# 🚀 Advanced Installer & Manager for AgenticSeek

![Language](https://img.shields.io/badge/Language-Bash-blue.svg)
![Environment](https://img.shields.io/badge/Environment-Docker-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

> **Robust bilingual installer** for [AgenticSeek (Fosowl's Fork)](https://github.com/Fosowl/agenticSeek)  
> Automates installation, configuration and management on Linux servers  
> Result of intensive debugging - handles common pitfalls seamlessly  

---

## 🌟 Features

- **Bilingual interface** (English/Español)
- **Smart detection** of existing installations
- **Quick install** (recommended defaults) vs **Custom setup** (full control)
- **Automatic fixes** for common issues:
  - Git credentials
  - Docker networking
  - Frontend-backend communication
- **Resource optimization** (external SearXNG by default)
- **Idempotent operations** - safe for repeated runs
- **Complete management menu**:
  - Start/Restart services
  - Stop containers
  - Real-time logs viewer
  - Complete reinstall option

---

## ⚙️ Prerequisites

- **OS**: Debian 11/12 or Ubuntu 20.04/22.04 (recommended)
- **Permissions**: `sudo` or `root` access
- **Resources**: Minimum 2GB RAM, 20GB disk space

---

## 🛠️ Installation & Usage

### Step 1: Download the script
```bash
wget -O setup.sh <URL_TO_YOUR_SCRIPT_FILE>
Step 2: Make executable
bash
chmod +x setup.sh
Step 3: Execute with privileges
bash
sudo ./setup.sh
Step 4: Follow interactive prompts
First run options:
Option	Description
Quick Install	Default ports (39899 web / 7777 API), public SearXNG instance
Custom Setup	Choose ports, enter API keys, configure SearXNG
Management menu (subsequent runs):
Start/Restart Services - Launch all containers

Stop Services - Shutdown running containers

View Logs - Real-time container logs (Ctrl+C to exit)

Reinstall - Complete wipe and fresh install (⚠️ use with caution)

Exit - Close the script

🔥 Critical Post-Install Step: Cloud Firewall
The script CANNOT configure cloud provider firewalls!
You must manually allow traffic:

Access your cloud console (AWS/GCP/Azure)

Navigate to VPC Network → Firewall

Create TWO ingress rules:

Frontend: TCP port 39899 (or your custom port)

Backend: TCP port 7777 (or your custom port)

Set source to 0.0.0.0/0 (anywhere)

🌐 Network Diagram
Diagram
Code
graph LR
    A[User Browser] --> B[Frontend :39899]
    A --> C[Backend API :7777]
    D[Server] --> E[External SearXNG]
    B --> D
    C --> D
❓ FAQ
Why can't I access the web interface?
Verify cloud firewall rules

Check if containers are running: sudo docker ps

Examine logs: sudo docker-compose -f agenticseek/docker-compose.yml logs

How to update?
Run the installer again - it will detect existing installation and offer update options

Where are configurations stored?
~/agenticseek/.env - Backend environment variables

~/agenticseek/frontend/.env - Frontend environment

Docker volumes persist data between restarts

📜 License
MIT License - See LICENSE file for details

🌎 Bilingual Documentation
English | Español
Español
🌟 Características
Interfaz bilingüe (Inglés/Español)

Detección inteligente de instalaciones existentes

Instalación rápida (valores por defecto) vs Configuración personalizada

Correcciones automáticas para problemas comunes

Optimización de recursos (SearXNG externo por defecto)

Operaciones idempotentes - seguro para ejecuciones múltiples

Menú completo de gestión

⚙️ Requisitos Previos
SO: Debian 11/12 o Ubuntu 20.04/22.04 (recomendado)

Permisos: Acceso sudo o root

Recursos: Mínimo 2GB RAM, 20GB disco

🛠️ Instalación y Uso
Paso 1: Descargar el script
bash
wget -O setup.sh <URL_DEL_SCRIPT>
Paso 2: Hacer ejecutable
bash
chmod +x setup.sh
Paso 3: Ejecutar con privilegios
bash
sudo ./setup.sh
Paso 4: Seguir instrucciones interactivas
Opciones primera ejecución:
Opción	Descripción
Instalación Rápida	Puertos predeterminados (39899 web/7777 API), SearXNG público
Configuración Personalizada	Elegir puertos, claves API, configurar SearXNG
Menú de gestión (ejecuciones posteriores):
Iniciar/Reiniciar Servicios

Detener Servicios

Ver Logs (Presione Ctrl+C para salir)

Reinstalar (⚠️ ¡Usar con precaución!)

Salir

🔥 Paso Crítico Post-Instalación: Firewall en la Nube
¡El script NO configura firewalls de proveedores en la nube!
Debes permitir manualmente:

Accede a tu consola (AWS/GCP/Azure)

Red VPC → Firewall

Crear DOS reglas de entrada:

Frontend: Puerto TCP 39899 (o tu puerto personalizado)

Backend: Puerto TCP 7777 (o tu puerto personalizado)

Origen: 0.0.0.0/0 (cualquier lugar)

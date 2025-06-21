# 🚀 Advanced Installer & Manager for AgenticSeek

![Language](https://img.shields.io/badge/Language-Bash-blue.svg)
![Environment](https://img.shields.io/badge/Environment-Docker-brightgreen.svg)
![License](https://img.shields.io/badge/License-GPLv3-blue.svg)


> **Robust bilingual installer** for [AgenticSeek (Fosowl's Fork)](https://github.com/Fosowl/agenticSeek)  
> Automates installation, configuration and management on Linux servers  
> Result of intensive debugging - handles common pitfalls seamlessly
> Made by Eddy F. T.

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
bash
wget -O setup.sh https://raw.githubusercontent.com/edfh0000/agenticseek-installbash-deb/refs/heads/main/setup.sh
## Step 2: Make executable
bash
chmod +x setup.sh
## Step 3: Execute with privileges
bash
sudo ./setup.sh
## Step 4: Follow interactive prompts
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

## 🔥 Critical Post-Install Step: Cloud Firewall
The script CANNOT configure cloud provider firewalls!
You must manually allow traffic:

Access your cloud console (AWS/GCP/Azure)

Navigate to VPC Network → Firewall

Create TWO ingress rules:

Frontend: TCP port 39899 (or your custom port)

Backend: TCP port 7777 (or your custom port)

Set source to 0.0.0.0/0 (anywhere)

# 🚀 Windows Powershell version

## Windows PowerShell Version

This repository also includes an advanced installer and manager script specifically for Windows environments (`setup.ps1`).

### Prerequisites

Before running the script, you must manually install the following tools:

1.  **Docker Desktop for Windows:** The official way to run Docker on Windows. Download it from the [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/). **Make sure it is running** before you execute the script.
2.  **Git for Windows:** Provides the `git` command line tool. Download it from [git-scm.com](https://git-scm.com/).

### Usage Guide

1.  **Open PowerShell as Administrator:**
    -   Click the Start Menu.
    -   Type "PowerShell".
    -   Right-click on "Windows PowerShell" and select **"Run as administrator"**.

2.  **Allow Script Execution (if needed):**
    By default, PowerShell might block running local scripts. If you get an error, you may need to change the execution policy for the current session. Run this command in your Administrator PowerShell window:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/edfh0000/agenticseek-installbash-deb/refs/heads/main/win_setup.ps1" -OutFile "setup.ps1"
    ```

3.  **Navigate to the Script and Run It:**
    Go to the directory where you saved `setup.ps1` and execute it:
    ```powershell
    .\setup.ps1
    ```

4.  **Follow On-Screen Instructions:**
    The script will guide you through the same "Quick Install" or "Custom Setup" process as the Linux version. The firewall rules for the chosen ports will be created automatically in Windows Defender Firewall.

5.  **Access the Application:**
    Once the installation is complete, you can access the web interface at `http://localhost:<Your-Frontend-Port>`.

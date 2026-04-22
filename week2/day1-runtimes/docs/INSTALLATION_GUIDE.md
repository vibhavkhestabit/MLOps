# Multi-Language Runtime Installation Guide

## Overview
This runbook details the automated provisioning of strictly isolated Node.js, Python, and PHP environments on a fresh Ubuntu/Debian server. We avoid OS-level global package managers for our primary runtimes to prevent forced updates from breaking application dependencies.

## Prerequisites
* Ubuntu 22.04 LTS (or compatible Debian-based OS)
* Sudo privileges
* Internet connectivity

## Step 1: Node.js Provisioning (via NVM)
We use the Node Version Manager (`nvm`) to handle our JavaScript environments, keeping our frontend (Next.js) and backend (Express) runtimes isolated.

**Execution:**
```
chmod +x ./scripts/node_installer.sh
./scripts/node_installer.sh
```
## What this does:

- Installs nvm directly via the official bash script without manual intervention.
- Installs versions v18.19.0, v20.11.0, and v22.0.0.
- **Sets v20.11.0 as the default version.**
- Generates a .nvmrc file in the user's home directory.(Note: Always run source ~/.bashrc after execution so the current shell picks up the nvm commands.)

## Step 2: Python Provisioning (via Pyenv)

To support our ML pipelines and FastAPI services safely, we compile Python from source using pyenv.

**Execution:**
```
chmod +x ./scripts/python_installer.sh
./scripts/python_installer.sh
```

## What this does:
- Installs necessary build dependencies (build-essential, libssl-dev, etc.) required to compile Python.
- Installs pyenv and compiles Python versions 3.9.18, 3.10.13, 3.11.7, and 3.12.1.
- **Sets 3.11.7 as the global default.**
- Upgrades pip and installs essential virtual environment tools (virtualenv, pipenv).

## Step 3: PHP Provisioning (via Ondrej PPA)

We utilize the ondrej/php PPA to install multiple PHP versions side-by-side using apt.

**Execution:**
```
chmod +x ./scripts/php_installer.sh
./scripts/php_installer.sh
```

## What this does:
- Adds the required PPA and installs PHP 7.4.33, 8.1.27, 8.2.15, and 8.3.2 along with their dependencies and php-fpm.
- Configures php-fpm for PHP 8.2 and sets 8.2 as the default CLI version.
- Installs Composer globally for dependency management.

## Step 4: System Verification and Tuning

Once the installers complete, verify the isolation and apply production resource limits.
1. Test the Version Switcher:Use our interactive tool to ensure you can dynamically shift between runtime versions:Bashsource ./scripts/runtime_version_switcher.sh
(Crucial: You must source this script, rather than executing it with ./, to ensure the version changes persist in your current terminal session.)
2. Audit the Installation:
Generate a comprehensive report of all installed runtimes, their paths, and current defaults:Bash./scripts/runtime_audit.sh
3. Apply Performance Tuning:
Inject production-grade memory and execution limits across all runtimes:Bash./scripts/performance_tuning.sh

```
source ~/.bashrc
```
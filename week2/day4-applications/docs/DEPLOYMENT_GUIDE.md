# Enterprise Multi-Stack Deployment Guide (Day 4)

## Architecture Overview
This document outlines the deployment procedures for a multi-language microservice architecture. The environment consists of three independent backend APIs (Node.js, Python, PHP) and one Server-Side Rendered frontend (Next.js).

**Deployment Path:** `/home/vibhavkhaneja/MLOps-Training/week2/day4-applications`

### Port Allocation Registry
| Service | Language | Framework | Database | Port | Process Manager |
|---|---|---|---|---|---|
| **Stack 1 API** | JavaScript | Express.js | PostgreSQL | `3000` | PM2 |
| **Stack 1 UI** | TypeScript | Next.js | N/A | `3001` | PM2 |
| **Stack 2 API** | Python | FastAPI | MySQL | `8000` | Systemd |
| **Stack 3 API** | PHP | Laravel | MySQL | `9000` | Systemd |


## Phase 1: Dependency Installation

Before launching processes, all application dependencies must be installed in their respective directories.

### 1. Express API
```
cd /home/vibhavkhaneja/MLOps-Training/week2/day4-applications/express-postgresql-api
npm install
```

### 2. Next.js Frontend
```
cd /home/vibhavkhaneja/MLOps-Training/week2/day4-applications/next-frontend
npm install
npm run build
```

### 3. FastAPI
```
cd /home/vibhavkhaneja/MLOps-Training/week2/day4-applications/fastapi-mysql-api
source venv/bin/activate
pip install -r requirements.txt
deactivate
```

### 4. Laravel API
```
cd /home/vibhavkhaneja/MLOps-Training/week2/day4-applications/laravel-mysql-api
composer install
```

## Phase 2: Database Initialization

Database schemas are fully automated via the enterprise migration runner script. This guarantees idempotent, version-controlled database structures.
1. Navigate to the master application directory:
cd /home/vibhavkhaneja/MLOps-Training/week2/day4-applications

2. Grant execution permissions (if not already set):
chmod +x run_migrations.sh

3. Execute the migration runner:
./run_migrations.sh


The script will systematically apply CREATE TABLE operations for Express (PostgreSQL), FastAPI (MySQL), and Laravel (MySQL).

## Phase 3: Process Daemonization
To ensure high availability and auto-restarts on system boot, all applications are daemonized using their native ecosystem standards.

### Part A: JavaScript Ecosystem (PM2)
PM2 is used to manage the Express API and Next.js frontend, utilizing the ecosystem.config.js file at the root of the day4-applications directory.

```
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### Part B: Linux Native Ecosystem (Systemd)
Systemd is used to manage the Python and PHP applications via isolated .service files located in /etc/systemd/system/.

```
sudo systemctl daemon-reload
sudo systemctl start fastapi
sudo systemctl enable fastapi
sudo systemctl start laravel-app
sudo systemctl enable laravel-app
```


## Phase 4: System Verification & Monitoring

Once all deployment phases are complete, use the automated watchdog script to verify system health.

1. Execute the monitor script:

```
./app_monitor.sh
```

2. Verification Checklist:
- All PM2 and Systemd statuses report as PASS.
- All ports (3000, 3001, 8000, 9000) respond to local curl requests.
- All /api/health endpoints return a 200 OK JSON response.

## Log Management

If any service reports as offline or unhealthy, consult the dedicated log files:
- Express: pm2 logs express-api
- Next.js: pm2 logs nextjs-app
- FastAPI: sudo journalctl -u fastapi -f
- Laravel: sudo journalctl -u laravel-app -f
- Health Monitor Audit Logs: ./logs/app_monitor_YYYY-MM-DD.log

![ss](../screenshots/ss34.png)
![ss](../screenshots/ss35.png)
![ss](../screenshots/ss36.png)

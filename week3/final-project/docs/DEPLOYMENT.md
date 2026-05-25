
# Deployment Documentation

# Introduction

This document explains how the project is deployed, managed, monitored, and maintained using Docker Compose and deployment automation scripts.

The deployment process was designed to simulate real-world production deployments.

---

# Deployment Strategy

The application uses:
- Docker
- Docker Compose
- Environment-based configuration

Three compose files were created:

1. docker-compose.yml
2. docker-compose.dev.yml
3. docker-compose.prod.yml

---

# Purpose of Multiple Compose Files

## Base Compose File

Contains:
- Common services
- Networks
- Volumes
- Shared configuration

This acts as the foundation.

---

## Development Compose File

Contains:
- Development overrides
- Debug-friendly settings
- Local development configurations

Used for:
- Local testing
- Development workflow

---

## Production Compose File

Contains:
- Production optimizations
- Restart policies
- Resource limits
- Security hardening

Used for:
- Production-style deployment

---

# Deployment Prerequisites

Required software:

- Docker
- Docker Compose
- Git

Verify installation:

```bash
docker --version
docker compose version
```

---

# Starting Development Environment

Command:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

Explanation:

- `-f` specifies compose files.
- Base file loads common configuration.
- Dev file overrides development-specific configuration.
- `up -d` runs containers in detached mode.
- `--build` rebuilds images before startup.

---

# Starting Production Environment

Command:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

This simulates production deployment.

---

# Deployment Script

A deployment automation script was created.

File:
`deploy.sh`

Purpose:
- Simplify deployments
- Reduce manual work
- Standardize startup process

Usage:

```bash
./deploy.sh dev
```

or

```bash
./deploy.sh prod
```

---

# Container Startup Flow

Startup sequence:

1. Databases start
2. Health checks validate databases
3. Backend services start
4. API Gateway starts
5. Frontend starts
6. Monitoring stack starts

This order prevents dependency failures.

---

# Health Checks

Health checks were implemented using Docker Compose.

Example:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8001/health"]
```

Purpose:
- Verify service availability
- Improve reliability
- Ensure proper startup

---

# Monitoring Verification

## Prometheus

URL:
http://localhost:9090

Used to:
- Verify scrape targets
- Monitor metrics

---

## Grafana

URL:
http://localhost:3001

Used to:
- Visualize dashboards
- Monitor containers

---

## cAdvisor

URL:
http://localhost:8081

Used to:
- Monitor Docker containers
- Track CPU and memory usage

---

# RabbitMQ Dashboard

URL:
http://localhost:15672

Credentials:
- Username: admin
- Password: ADMIN123

Purpose:
- Monitor queues
- View connections
- Observe message flow

---

# Backup System

A backup automation script was implemented.

File:
`backup.sh`

Features:
- PostgreSQL backups
- MongoDB backups
- Timestamped backup folders
- Compose file backups

Example command:

```bash
./backup.sh
```

---

# Backup Storage Structure

Example:

```bash
backups/
├── 20260525_132743/
│   ├── users_db.sql
│   ├── mongodb-backup/
│   ├── docker-compose.yml
│   ├── docker-compose.dev.yml
│   └── docker-compose.prod.yml
```

---

# Security During Deployment

Security improvements included:

- Non-root containers
- Trivy image scanning
- Network isolation
- Health checks
- Production restart policies

---

# Troubleshooting

## Port Already in Use

Check:

```bash
sudo lsof -i :8010
```

Kill conflicting process if needed.

---

## Rebuild Containers

```bash
docker compose build
docker compose up -d
```

---

# Remove Containers and Volumes

```bash
docker compose down -v
```

Purpose:
- Clean environment
- Remove persistent volumes

---

# Learning Outcomes

Through deployment implementation, the following concepts were learned:

- Environment-based deployments
- Service orchestration
- Container lifecycle management
- Monitoring integration
- Automated backups
- Health checks
- Docker networking
- Deployment automation

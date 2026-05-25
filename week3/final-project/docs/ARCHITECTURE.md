
# Architecture Documentation

# System Architecture Overview

The project follows a distributed microservices architecture.

Instead of building one large monolithic application, the application was split into multiple independent services. Each service has a dedicated responsibility and communicates through APIs and messaging systems.

This architecture improves:
- Scalability
- Maintainability
- Fault isolation
- Independent deployments

---

# High-Level Request Flow

Client
↓
Frontend (React + Nginx)
↓
API Gateway
↓
Microservices
├── User Service
├── Product Service
└── Order Service
↓
Databases + Cache + Queue

---

# Frontend Architecture

## React Frontend

The frontend application was built using React and Vite.

Responsibilities:
- User interface rendering
- Sending API requests
- Displaying responses
- Client-side routing

---

## Nginx

Nginx was used to serve production frontend files.

Reasons for using Nginx:
- Fast static file serving
- Production optimization
- Lightweight container
- Reverse proxy capability

---

# API Gateway Architecture

The API Gateway acts as the central entry point for backend services.

Technology:
- Node.js
- Express

Responsibilities:
- Request routing
- Centralized API access
- Rate limiting
- Request forwarding

Example routing:

- `/api/users` → User Service
- `/api/products` → Product Service
- `/api/orders` → Order Service

Benefits:
- Single entry point
- Easier frontend integration
- Better security control

---

# User Service

Technology:
- FastAPI
- SQLAlchemy
- PostgreSQL

Responsibilities:
- User management
- Database operations
- User APIs

Internal Port:
8001

External Port:
8010

Health Endpoint:
`/health`

Metrics Endpoint:
`/metrics`

---

# Product Service

Technology:
- Node.js
- Express
- MongoDB

Responsibilities:
- Product APIs
- Product catalog management

Internal Port:
8002

External Port:
8011

---

# Order Service

Technology:
- FastAPI
- RabbitMQ
- PostgreSQL

Responsibilities:
- Order processing
- Queue communication
- Event processing

Internal Port:
8003

External Port:
8012

---

# Database Architecture

## PostgreSQL

Used for:
- User data
- Order data

Reason:
Relational databases are ideal for structured transactional data.

Persistence:
Named Docker volume.

---

## MongoDB

Used for:
- Product data

Reason:
Flexible schema design for products.

Persistence:
Named Docker volume.

---

## Redis

Used for:
- Caching
- Faster responses

Benefits:
- Reduced database load
- Improved API performance

---

# Messaging Architecture

## RabbitMQ

RabbitMQ was used for asynchronous communication.

Benefits:
- Decoupled architecture
- Better scalability
- Reliable message delivery

Use cases:
- Order events
- Background processing

---

# Monitoring Architecture

# Prometheus

Prometheus continuously scrapes metrics from services.

Metrics collected:
- HTTP requests
- CPU usage
- Memory usage
- Container metrics

---

# Grafana

Grafana visualizes metrics from Prometheus.

Dashboards display:
- Container health
- Resource usage
- Service metrics

---

# cAdvisor

cAdvisor directly monitors Docker containers.

It provides:
- CPU metrics
- Memory metrics
- Network metrics
- Filesystem metrics

---

# Docker Compose Architecture

Docker Compose orchestrates the complete stack.

Responsibilities:
- Service startup
- Networking
- Volumes
- Dependencies
- Health checks

---

# Health Check Architecture

Each service exposes:
`/health`

Docker Compose uses health checks to verify container availability.

This ensures:
- Proper startup order
- Better reliability
- Automatic failure detection

---

# Security Architecture

## Non-Root Containers

Containers were configured to run as non-root users.

Benefits:
- Reduced privilege escalation risk
- Better container isolation

---

## Network Isolation

Three Docker networks were used.

Purpose:
- Restrict communication
- Improve security
- Separate layers

---

## Trivy Scanning

All images were scanned using Trivy.

Purpose:
- Detect vulnerabilities
- Improve image security
- Production readiness

---

# Deployment Architecture

Separate environments were implemented:

- Development
- Production

Separate compose override files were used.

Benefits:
- Cleaner deployments
- Easier configuration management
- Better production optimization


# API Documentation

# Introduction

This document explains all API services, endpoints, routes, monitoring endpoints, and communication structure implemented in the project.

The application consists of multiple independent microservices connected through an API Gateway.

---

# API Gateway

Base URL:

```bash
http://localhost:5000
```

The API Gateway acts as the central entry point for all backend communication.

Responsibilities:
- Request routing
- API abstraction
- Centralized access
- Rate limiting

---

# User Service API

Base URL:

```bash
http://localhost:8010
```

Technology:
- FastAPI
- PostgreSQL
- SQLAlchemy

Purpose:
- Manage user data

---

## Health Check Endpoint

Endpoint:

```bash
GET /health
```

Purpose:
- Verify service availability

Example response:

```json
{
  "status": "OK",
  "service": "user-service"
}
```

---

## Get Users Endpoint

Endpoint:

```bash
GET /users
```

Purpose:
- Fetch user list

Example response:

```json
[
  {
    "id": 1,
    "name": "Vibhav",
    "email": "vibhav@example.com"
  }
]
```

---

# Product Service API

Base URL:

```bash
http://localhost:8011
```

Technology:
- Node.js
- Express
- MongoDB

Purpose:
- Manage products

---

## Health Check

```bash
GET /health
```

Purpose:
- Service monitoring

---

## Products Endpoint

```bash
GET /products
```

Purpose:
- Fetch product data

---

# Order Service API

Base URL:

```bash
http://localhost:8012
```

Technology:
- FastAPI
- PostgreSQL
- RabbitMQ

Purpose:
- Manage orders

---

## Health Check

```bash
GET /health
```

Purpose:
- Verify service availability

---

## Orders Endpoint

```bash
GET /orders
```

Purpose:
- Retrieve order data

---

# Metrics Endpoints

Each service exposes:

```bash
/metrics
```

Purpose:
- Prometheus metrics scraping

Metrics include:
- Request counts
- Request duration
- Error counts
- Resource usage

---

# Monitoring APIs

## Prometheus

URL:

```bash
http://localhost:9090
```

Purpose:
- Query metrics
- Verify scrape targets

---

## Grafana

URL:

```bash
http://localhost:3001
```

Purpose:
- Dashboard visualization

---

## cAdvisor

URL:

```bash
http://localhost:8081
```

Purpose:
- Container monitoring

Provides:
- CPU usage
- Memory usage
- Filesystem metrics
- Network metrics

---

# RabbitMQ Dashboard

URL:

```bash
http://localhost:15672
```

Credentials:

```bash
Username: admin
Password: ADMIN123
```

Purpose:
- Monitor queues
- Monitor consumers
- Monitor producers

---

# Health Check Strategy

Every service exposes a health endpoint.

Docker Compose uses these endpoints to:
- Determine service readiness
- Verify uptime
- Control startup order

---

# Service Communication

## Frontend to Gateway

Frontend sends requests to API Gateway.

---

## Gateway to Services

API Gateway routes requests internally.

---

## Services to Databases

- User Service → PostgreSQL
- Product Service → MongoDB
- Order Service → PostgreSQL

---

## Services to Queue

Order Service communicates with RabbitMQ.

---

# Error Handling

Implemented features:
- HTTP status codes
- Health verification
- Container restart policies

---

# Security Considerations

Security measures:
- Network isolation
- Non-root containers
- Vulnerability scanning
- Health checks

---

# API Testing

Testing commands used:

## Health Checks

```bash
curl localhost:8010/health
curl localhost:8011/health
curl localhost:8012/health
```

---

## User API

```bash
curl localhost:8010/users
```

---

# Conclusion

The APIs were designed following a microservices architecture where each service is independently deployable, independently monitorable, and isolated through Docker networking.

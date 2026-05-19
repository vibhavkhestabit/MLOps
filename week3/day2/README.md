# Week 3 - Day 2 Docker Bootcamp

## Overview

This day was focused on multi-container application orchestration using Docker Compose.

Day 1 was about understanding how a single container works. Day 2 was about understanding how multiple containers work together as a system.

Instead of only writing Dockerfiles, the goal was to understand:
- how real applications are structured across multiple containers
- how containers discover and communicate with each other
- how the same application behaves differently in development versus production
- how to manage configuration, health, scaling, and environment separation

We worked with:
- 3-tier architecture (React + Node.js + PostgreSQL)
- Multi-environment Compose files (base, override, prod)
- MERN stack (MongoDB + Express + React + Nginx)
- Laravel + MySQL + Redis + PHP-FPM + Queue workers
- Health check patterns for different application types
- Environment variable management and `.env` strategies
- Horizontal service scaling with Nginx load balancing

This day felt like the point where Docker stopped being about individual containers and started being about operating distributed systems. Every exercise forced understanding of how services depend on each other and how production deployments are actually structured.

---

## Exercise 1 — 3-Tier Application with Docker Compose

We built a complete `docker-compose.yml` defining three coordinated services: a React frontend served by Nginx, a Node.js Express backend, and a PostgreSQL database.

Main concepts covered:
- defining multiple services in a single Compose file
- port mappings and internal service communication
- environment variables passed to containers
- volume persistence for database data
- `depends_on` with health check conditions
- restart policies

### Learning

The most important shift from Day 1 was understanding how containers talk to each other.

Inside a Docker network, containers do not use `localhost` to communicate. They use service names defined in `docker-compose.yml`.

So when the backend needed to reach the database, the connection string was:

```
DB_HOST: db
```

not `localhost` or an IP address. Docker's internal DNS resolved `db` to the correct container automatically. This is how every real multi-container system works.

We also learned why `depends_on` alone is not enough. A container can start without being ready. PostgreSQL for example needs time to initialize its data directory before it accepts connections. Just because the container started does not mean the service is ready.

The correct pattern was:

```yaml
depends_on:
  db:
    condition: service_healthy
```

Combined with a health check:

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 5s
  timeout: 5s
  retries: 5
```

This meant the backend container would only start after the database was genuinely accepting connections, not just after its container launched.

One more key realization: volumes are what make databases actually useful in Docker. Without a named volume, all data disappears when the container is removed.

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
```

![ss](screenshots/ex1-1.png)
![ss](screenshots/ex1-2.png)
![ss](screenshots/ex1-3.png)
![ss](screenshots/ex1-4.png)

---

## Exercise 2 — Multi-Environment Compose Files

We evolved the same 3-tier application into a proper multi-environment setup using three separate Compose files:

- `docker-compose.yml` — base configuration shared across all environments
- `docker-compose.override.yml` — development-specific additions
- `docker-compose.prod.yml` — production-specific additions

### Learning

This exercise introduced one of the most important patterns in real DevOps workflows.

The core idea is that you never duplicate your entire Compose configuration just because dev and prod behave differently. Instead you express only what changes per environment and let Compose merge the layers together.

The mental model worked like this:

```
docker-compose.yml         ← always loaded (base)
       +
docker-compose.override.yml  ← auto-loaded in dev
       =
complete dev configuration

docker-compose.yml         ← always loaded (base)
       +
docker-compose.prod.yml    ← manually specified for prod
       =
complete prod configuration
```

Development needed hot reload, so the override mounted live source code into the container:

```yaml
volumes:
  - ./backend:/app
  - /app/node_modules
command: npm run dev
```

Production needed a stable optimized build, so the prod file changed the startup command and added restart policies:

```yaml
command: node server.js
restart: always
```

The base file held everything true in both environments: database config, health checks, port mappings, dependency conditions.

Running dev was as simple as:

```
docker compose up
```

Compose automatically detected and merged the override file by name convention.

Running prod required specifying files explicitly:

```
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
```

The `-f` flag tells Compose exactly which files to merge and in what order. Using it also prevents the override from being auto-loaded, which is the correct behavior for production.

We also encountered a subtle bug during this exercise. The frontend image was corrupted because Docker had accidentally tagged the intermediate Node build stage as `node:20-alpine` locally. This caused `npm: not found` errors inside what should have been a Node container.

The fix was:

```
docker rmi node:20-alpine --force
docker pull node:20-alpine
```

This debugging experience was very valuable because it demonstrated that image corruption can cause confusing errors and that `docker pull` forces a clean re-download rather than reusing a potentially broken local cache.

![ss](screenshots/ex2-1.png)
![ss](screenshots/ex2-2.png)
![ss](screenshots/ex2-3.png)
![ss](screenshots/ex2-4.png)
![ss](screenshots/ex2-5.png)

---

## Exercise 3 — MERN Stack with Docker Compose

We built a complete MERN stack: MongoDB database, Express.js API with JWT authentication, React frontend built with Vite, and Nginx as a reverse proxy.

Main concepts covered:
- MongoDB with Mongoose ODM
- JWT-based authentication endpoints
- Vite frontend building and serving
- Nginx proxying `/api/*` traffic internally to the backend
- `.env` file for centralized configuration

### Learning

The most important architectural shift in this exercise was how Nginx changed the communication pattern.

In Exercise 1, the frontend directly called the backend on its exposed port. In Exercise 3, Nginx sat in between. The frontend never knew where the backend was. It only sent requests to `/api/*` and Nginx internally forwarded them to the backend service.

```nginx
location /api/ {
    proxy_pass http://backend:5000/api/;
}
```

This is the production pattern. Backend services are not exposed publicly. Users only interact with Nginx. The backend port never needs to appear in any URL the user sees.

We also used `.env` files properly for the first time across a full stack. A single `.env` at the project root drove configuration across every service:

```
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=secret
JWT_SECRET=your-secret-key
API_PORT=5000
```

And Compose read those values using substitution syntax:

```yaml
environment:
  MONGO_URI: mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@mongo:27017/${MONGO_DB_NAME}?authSource=admin
```

This separation of secrets from code is how all real deployments are managed.

MongoDB health checks also worked differently compared to PostgreSQL. The correct check for MongoDB 7 used `mongosh`:

```yaml
test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
```

![ss](screenshots/ex3-1.png)
![ss](screenshots/ex3-2.png)
![ss](screenshots/ex3-3.png)

---

## Exercise 4 — Laravel + MySQL + Redis Stack

This was the most operationally complex exercise of the day. We set up a full enterprise PHP stack with Laravel, MySQL 8.0, Redis, Nginx, PHP-FPM, and a separate queue worker container.

Main concepts covered:
- PHP-FPM serving Laravel behind Nginx
- Redis handling caching, sessions, and queues simultaneously
- Composer dependency installation inside Docker builds
- Queue workers as independent containers
- Health checks for MySQL and Redis
- Volume persistence for MySQL data

### Learning

PHP applications run differently from Node.js or Python applications in Docker.

Node.js starts its own HTTP server. PHP cannot do that in production. Instead PHP runs through PHP-FPM, a process manager that handles PHP execution. Nginx sits in front and passes PHP requests to PHP-FPM through a socket:

```nginx
location ~ \.php$ {
    fastcgi_pass app:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```

This means a PHP stack always needs two containers working together just to serve web requests: Nginx and the PHP-FPM container. Understanding this pattern was a major step toward understanding enterprise application infrastructure.

Redis served three distinct purposes simultaneously in this stack:

```
Cache driver  → faster page loads, avoids repeated DB queries
Session driver → stores user sessions instead of file system
Queue driver  → powers background job processing
```

Using Redis for all three is the standard Laravel production pattern.

The queue worker was the most interesting architectural detail. Rather than cramming background job processing into the main app container, we ran it as an entirely separate container with a different startup command:

```yaml
queue:
  build: ./laravel
  command: php artisan queue:work --sleep=3 --tries=3
```

Same image, different behavior, different container. This is how microservice-style worker scaling works in practice.

The MySQL health check also required careful construction to avoid false positives

![ss](screenshots/ex4-1.png)
![ss](screenshots/ex4-2.png)
![ss](screenshots/ex4-3.png)

---

## Exercise 5 — Health Check Scripts

We built dedicated health check scripts for Node.js and Python applications, implemented both `/health` and `/ready` endpoints, and created a reference Compose file showing the correct health check pattern for every major service type.

Main concepts covered:
- liveness probes versus readiness probes
- custom shell scripts as health check commands
- `start_period` for startup grace periods
- health checks for PostgreSQL, Redis, MongoDB, Node.js, and Python

### Learning

This exercise introduced a distinction that matters enormously in production: liveness versus readiness.

They sound similar but serve completely different purposes:

```
/health  → is the process alive?
           Answer: can the container respond at all?
           Docker uses this to decide whether to RESTART the container.

/ready   → is the app ready to serve traffic?
           Answer: is the DB connected, cache warm, config loaded?
           Load balancers use this to decide whether to ROUTE traffic here.
```

A container can be alive but not ready. For example, a Node.js server might start listening on port 3000 immediately, but if the database connection hasn't been established yet, it should not receive traffic. The `/ready` endpoint handles this correctly.

The custom Node.js health check script demonstrated how to use exit codes to communicate health status:

```sh
HTTP_CODE=$(wget --server-response --spider -q http://localhost:3000/health 2>&1 \
  | awk '/^  HTTP/{print $2}' | tail -1)

if [ "$HTTP_CODE" = "200" ]; then
  exit 0   # healthy
else
  exit 1   # unhealthy — Docker will restart or mark container unhealthy
fi
```

The `start_period` configuration was another important detail:

```yaml
healthcheck:
  start_period: 15s
```

This tells Docker not to count health check failures during the first 15 seconds of container startup. Without this, a slow-starting application would get killed before it had time to initialize.

Every service type has its own idiomatic health check:

| Service    | Health Check Command |
|------------|----------------------|
| PostgreSQL | `pg_isready -U user` |
| MySQL      | `mysqladmin ping`    |
| Redis      | `redis-cli ping`     |
| MongoDB    | `mongosh --eval "db.adminCommand('ping')"` |
| Node.js    | `wget --spider http://localhost:3000/health` |
| Python     | `python -c "import urllib.request; urllib.request.urlopen(...)"` |

---

## Exercise 6 — Environment Variable Management

We created a complete environment variable management system using `.env`, `.env.example`, `.env.dev`, and `.env.prod` files, and demonstrated how Compose reads, substitutes, and overrides variables across different environments.

Main concepts covered:
- `.env` as the default variable source for Compose
- `.env.example` as a safe public template
- variable substitution syntax in Compose files
- `env_file` versus `environment` block differences
- running Compose with different environment files

### Learning

Environment variable management is where configuration security either works or fails.

The fundamental rule is:

```
.env          → real values, NEVER committed to git
.env.example  → template with no secrets, ALWAYS committed to git
```

`.env.example` documents every variable the project needs without exposing any actual credentials. When a new developer clones the repo they run:

```
cp .env.example .env
```

and fill in real values. This is the standard industry pattern.

Compose has two different ways to pass variables to containers and they behave differently:

```yaml
# env_file loads ALL variables from a file into the container
env_file:
  - .env

# environment block sets specific variables, can use substitution
environment:
  NODE_ENV: ${APP_ENV:-production}
  DB_URL: postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
```
---

## Exercise 7 — Service Scaling with Docker Compose

We configured a Node.js API service to run as multiple replicas simultaneously, placed Nginx in front as a load balancer using an `upstream` block, and demonstrated round-robin traffic distribution across all replicas.

Main concepts covered:
- horizontal scaling with `--scale`
- why `ports` cannot be used on scaled services
- `expose` for internal-only container communication
- Nginx `upstream` block for load balancing
- Docker DNS resolving service names to multiple IPs

### Learning

Scaling revealed a constraint that was easy to miss until hitting it directly.

When a service defines:

```yaml
ports:
  - "3000:3000"
```

it tries to bind host port 3000 to the container. If you scale to 3 replicas, all three containers try to bind the same host port. That causes an immediate conflict and a crash.

The solution is to remove host port bindings and use `expose` instead:

```yaml
expose:
  - "3000"
```

`expose` makes the port available to other containers on the internal Docker network but does not bind anything on the host machine. Replicas can each have their own internal port 3000 without conflict because they are on different internal IPs.

Nginx then became the single entry point:

```nginx
upstream api_cluster {
    server api:3000;
}
```

Docker's internal DNS is what made this work elegantly. When Nginx resolved `api`, it did not get a single IP. It got the IPs of all running replicas. Nginx then distributed requests across them in round-robin order automatically.

Each response showed a different container hostname, confirming that traffic was being distributed across all three replicas.

Scaling up and down was a single command:

```bash
docker compose up -d --scale api=3
docker compose up -d --scale api=1
```

No rebuilds, no restarts of other services. Just new replicas being added or removed from the pool.

| Replicas | Command |
|----------|---------|
| Scale up to 3 | `docker compose up -d --scale api=3` |
| Scale back to 1 | `docker compose up -d --scale api=1` |
| View all replicas | `docker compose ps` |
| Logs from all replicas | `docker compose logs -f api` |

![ss](screenshots/ex7-1.png)
![ss](screenshots/ex7-2.png)

---

## Architecture Comparison Across the Day

| Exercise | Stack | Key Pattern Introduced |
|---|---|---|
| Ex1 | React + Node.js + PostgreSQL | Multi-container orchestration, service DNS |
| Ex2 | Same 3-tier | Environment-based Compose layering |
| Ex3 | MERN (MongoDB + Express + React + Nginx) | Reverse proxy, centralized env config |
| Ex4 | Laravel + MySQL + Redis + PHP-FPM | Enterprise stack, worker containers |
| Ex5 | All types | Liveness vs readiness, health check scripts |
| Ex6 | Any stack | Env file management, configuration security |
| Ex7 | Node.js + Nginx | Horizontal scaling, load balancing |

---

## Major Concepts Learned Throughout the Day

### 1. Container DNS and Internal Communication

Containers communicate using service names, not `localhost` or IP addresses. Docker's internal DNS resolves `db`, `redis`, `backend` to the correct container automatically. This is the foundation of every multi-container setup.

### 2. Health Checks as Startup Orchestration

`depends_on` only waits for a container to start, not for the service to be ready. Health checks combined with `condition: service_healthy` create actual readiness-based startup ordering. Every production setup needs this.

### 3. Compose File Layering

Base configuration plus environment-specific overrides. Never duplicate. The override file auto-loads for dev. The prod file is specified explicitly with `-f`. This pattern scales from small projects to enterprise deployments.

### 4. Reverse Proxy Pattern

Backend services should not be exposed publicly. Nginx sits in front, routes traffic internally, and becomes the only public entry point. Users never see backend ports or service names.

### 5. Expose vs Ports

`ports` binds to the host machine. `ports` on a scaled service causes conflicts because multiple containers cannot share one host port. `expose` makes ports available internally only and is required for scaling.

### 6. Environment Variable Separation

`.env` holds real secrets and is never committed. `.env.example` is the public template. Compose reads `.env` automatically and supports substitution with defaults. Configuration is never hardcoded.

### 7. Queue Workers as Separate Containers

Background job processing runs in its own container using the same image but a different command. This allows independent scaling of web and worker processes and is the standard pattern in Laravel, Django, Rails, and similar frameworks.

---

## Final Reflection

Day 1 taught how containers work. Day 2 taught how systems work.

The exercises moved from "here is how to run a container" to "here is how a production application is actually deployed." The shift was significant. Every concept built directly on the previous one and by the end of the day the architecture of real-world applications made much more sense.

The most important single realization of the day was that service names replace localhost. Everything else — health checks, reverse proxying, scaling, environment management — is built on top of that foundation.

The debugging moments were again the most valuable parts. The corrupted `node:20-alpine` image, the MySQL health check syntax, the port conflict when scaling — these were not failures. They were the actual learning. Reading about Docker Compose and operating Docker Compose are entirely different experiences.

The biggest takeaway was that Docker Compose is not a development convenience tool. It is a production orchestration system that mirrors exactly how Kubernetes, ECS, and other container platforms think about services, health, configuration, and scale. Learning Compose deeply is learning distributed systems thinking in a practical and immediate way.
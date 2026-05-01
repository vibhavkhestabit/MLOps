# Day 4: Application Development & Process Management
**Author:** Vibhav Khaneja | **Project:** DevOps Launchpad Week 2

##  Aim of the Day
The objective of Day 4 was to build complete, functional REST API applications across three distinct programming languages (Node.js, Python, PHP) and effectively manage their lifecycles. We focused on implementing production-ready features like connection pooling, structured logging, health check endpoints, and robust process management using PM2 and Systemd.

##  Project Structure & Tech Stacks

The `day4-applications/` directory houses four main projects, representing the core components of our three tech stacks.

### 1. `express-postgresql-api/` (Stack 1 Backend)
*   **Framework:** Node.js + Express.js
*   **Purpose:** A RESTful API handling User CRUD operations.
*   **Key Features:**
    *   **Connection Pooling:** Utilizes `pg.Pool` to efficiently manage PostgreSQL connections, preventing database exhaustion under load.
    *   **Middleware:** Implements request logging via `morgan` and structured application logging via `winston`.
    *   **Process Management:** Managed by PM2 in cluster mode to utilize multiple CPU cores.

![ss](../screenshots/ss1.png)
![ss](../screenshots/ss2.png)
![ss](../screenshots/ss3.png)
![ss](../screenshots/ss4.png)
![ss](../screenshots/ss5.png)
![ss](../screenshots/ss6.png)
![ss](../screenshots/ss7.png)
![ss](../screenshots/ss8.png)
![ss](../screenshots/ss9.png)

### 2. `fastapi-mysql-api/` (Stack 3 Backend)
*   **Framework:** Python + FastAPI
*   **Purpose:** An asynchronous, high-performance API for product management.
*   **Key Features:**
    *   **Async Operations:** Uses `aiomysql` for non-blocking database transactions.
    *   **Validation:** Leverages Pydantic models for strict request/response validation and automatic OpenAPI documentation generation.
    *   **Process Management:** Deployed using Uvicorn ASGI server and managed by Systemd (`fastapi.service`).

![ss](../screenshots/ss10.png)
![ss](../screenshots/ss11.png)
![ss](../screenshots/ss12.png)
![ss](../screenshots/ss13.png)
![ss](../screenshots/ss14.png)
![ss](../screenshots/ss15.png)

### 3. `laravel-mysql-api/` (Stack 2 Full-Stack/Backend)
*   **Framework:** PHP + Laravel
*   **Purpose:** A robust API managing tasks, utilizing Laravel's MVC architecture.
*   **Key Features:**
    *   **MVC Architecture:** Separates concerns into Models (Eloquent ORM), Views (or API responses), and Controllers.
    *   **Queue Workers:** Configured asynchronous job processing for heavy tasks, managed by a dedicated Systemd worker service.
    *   **Process Management:** Core API and Queue Workers are managed natively by Systemd (`laravel-worker.service`).

![ss](../screenshots/ss16.png)
![ss](../screenshots/ss17.png)
![ss](../screenshots/ss18.png)
![ss](../screenshots/ss19.png)
![ss](../screenshots/ss20.png)
![ss](../screenshots/ss21.png)
![ss](../screenshots/ss22.png)

### 4. `next-frontend/` (Stacks 1 & 3 Frontend)
*   **Framework:** React + Next.js
*   **Purpose:** A Server-Side Rendered (SSR) user interface interacting with the backend APIs.
*   **Key Features:**
    *   **API Routes:** Acts as an intermediate layer for secure data fetching.
    *   **Process Management:** Managed by PM2, running multiple instances to handle concurrent frontend requests.

![ss](../screenshots/ss23.png)
![ss](../screenshots/ss24.png)
![ss](../screenshots/ss25.png)
![ss](../screenshots/ss26.png)
![ss](../screenshots/ss27.png)
![ss](../screenshots/ss28.png)

## Process Management: PM2 vs. Systemd

A core focus of Day 4 was understanding and implementing process managers to ensure high availability and automatic recovery.

### PM2 (Process Manager 2)
Used primarily for the JavaScript ecosystems (`express-postgresql-api` and `next-frontend`).
*   **Configuration:** The `ecosystem.config.js` file dictates how PM2 handles the apps.
*   **Cluster Mode:** Allows Node.js (a single-threaded runtime) to scale horizontally across all available CPU cores by spawning multiple worker processes.
*   **Features Used:** Auto-restart on failure, memory limits (`max_memory_restart`), and centralized log file definitions.

### Systemd
Used for the Python (`fastapi-mysql-api`) and PHP (`laravel-mysql-api`) applications.
*   **Configuration:** Custom `.service` files located in `/etc/systemd/system/`.
*   **Mechanics:** Integrates deeply with the Linux kernel's init system.
*   **Features Used:** Defined `WorkingDirectory`, `ExecStart` commands (e.g., launching Uvicorn or Artisan queue workers), and strict `Restart=always` policies to ensure continuous uptime.

![ss](../screenshots/ss29.png)
![ss](../screenshots/ss30.png)
![ss](../screenshots/ss31.png)
![ss](../screenshots/ss32.png)
![ss](../screenshots/ss33.png)

##  Automation & Monitoring Scripts

*   `app_monitor.sh`: A comprehensive script that probes both PM2 and Systemd processes, verifies port availability, hits the `/api/health` endpoints, and tracks memory/CPU utilization.
*   `run_migrations.sh`: Automates the sequential execution of database schema migrations across all three applications (Express, FastAPI, and Laravel).

![ss](../screenshots/ss34.png)
![ss](../screenshots/ss35.png)
![ss](../screenshots/ss36.png)

##  Key Takeaways
Day 4 bridged the gap between raw code and deployable services. By implementing connection pooling and robust process managers (PM2 and Systemd), the applications are now prepared to handle the load balancing and stress testing introduced in Day 5.
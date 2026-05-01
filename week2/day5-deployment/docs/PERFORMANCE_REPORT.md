# Load Testing & Performance Analysis
**Author:** Vibhav Khaneja | **Date:** 2026-05-01

## Methodology
Load testing was conducted using **Apache Bench (ab)**. 
*   **Parameters:** 10,000 total requests, 100 concurrent users.
*   **Target:** Local `/api/health` endpoints to evaluate raw backend throughput and process manager stability.

## Results Analysis

### Stack 1 (Node.js/Next.js via PM2)
*   **Requests Per Second (RPS):** 2,063.13
*   **Average Response Time:** 48.47 ms
*   **Failure Rate:** ~9.6% (964 failed requests)
*   **Analysis:** Highly performant under standard loads, but the single-threaded nature of Node.js event loops resulted in dropped connections during extreme concurrency spikes.

### Stack 2 (PHP/Laravel via Systemd)
*   **Requests Per Second (RPS):** 225.14
*   **Average Response Time:** 444.16 ms
*   **Failure Rate:** 0%
*   **Analysis:** Exhibits classic monolithic blocking architecture. Significantly lower throughput than asynchronous frameworks, but provided 100% stability with zero dropped connections by heavily queuing requests.

### Stack 3 (Python/FastAPI via Systemd)
*   **Requests Per Second (RPS):** 742.03
*   **Average Response Time:** 134.76 ms
*   **Failure Rate:** 0%
*   **Analysis:** The optimal balance. FastAPI's ASGI asynchronous handling delivered high throughput (3x faster than Laravel) while maintaining perfect stability under pressure.

## Applied Optimizations
Following the baseline tests, the following infrastructure optimizations were applied via `performance_optimizer.sh` and `caching_setup.sh`:
1.  **Redis Caching Layer:** Configured with `maxmemory 256mb` and `allkeys-lru` eviction policy.
2.  **Kernel Tuning:** Increased `fs.file-max` to 1,000,000 and expanded ephemeral ports (`net.ipv4.ip_local_port_range`).
3.  **Nginx Tuning:** Increased `worker_connections` to 4096.

![ss](../screenshots/load_test_runner.png)
![ss](../screenshots/performance.png)
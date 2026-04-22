# Runtime Performance Tuning Guidelines

## Overview
Out of the box, standard language runtimes are configured with conservative resource limits designed to run safely on minimal hardware. For our production and data-intensive ML workloads, these default ceilings lead to bottlenecks, silent failures, and Out-Of-Memory (OOM) crashes. 

This guide details the explicit optimizations applied across our infrastructure to ensure maximum throughput and stability.

## Node.js Optimizations
These parameters are injected globally via the `NODE_OPTIONS` environment variable.

* **`--max-old-space-size=4096`**
  The V8 JavaScript engine caps its garbage collection heap memory around 1.5GB to 2GB by default. When our Next.js servers or Express APIs process large JSON payloads or ML model bridges, they can quickly hit this limit, resulting in a fatal allocation failure. By explicitly bumping this to 4096MB (4GB), we give our Node processes sufficient headroom for heavy data transformation.

* **`--max-http-header-size=16384`**
  Modern decoupled architectures often rely on massive authentication tokens (like bloated JWTs) passing through the headers. The default HTTP header limit in Node can be too restrictive, causing mysterious `431 Request Header Fields Too Large` errors. Expanding this to 16KB prevents these authentication bottlenecks at the gateway layer.

## Python Optimizations
These variables are exported directly into the `~/.bashrc` profile, ensuring they apply seamlessly to any active `pyenv` instance.

* **`PYTHONOPTIMIZE=1`**
  Instructs the Python interpreter to run in optimized mode. This effectively strips out `assert` statements and removes code blocks wrapped in `if __debug__:`. While the performance gain is slight, it reduces compiled bytecode size and shaves off execution time for our heavily algorithmic FastAPI endpoints and multi-agent orchestrations.

* **`PYTHONUNBUFFERED=1`**
  Crucial for DevOps observability. By default, Python buffers its standard output (`stdout`) and standard error (`stderr`). If a background worker or API crashes unexpectedly, buffered logs can be lost before they write to the console. Forcing unbuffered output ensures our logs stream immediately to our monitoring tools in true real-time.


## PHP-FPM Optimizations
These settings are applied directly to the PHP-FPM configuration files (e.g., `/etc/php/[version]/fpm/php.ini`).

* **`memory_limit = 256M`**
  Standard default is usually 128M. Increasing this to 256MB allows Laravel to handle larger datasets, file uploads, and heavy asynchronous queue jobs without throwing fatal memory exhaustion errors, while still enforcing a strict enough ceiling to prevent a runaway process from consuming the entire server's RAM.

* **`max_execution_time = 300`**
  Extends the maximum execution time from the default 30 seconds to 300 seconds (5 minutes). This is vital for background processes and API endpoints that communicate with slow external services or perform complex database aggregations.

* **`opcache.enable=1`**
  As an interpreted language, PHP traditionally recompiles scripts on every request. Enabling OPcache stores precompiled script bytecode in shared memory, vastly reducing CPU overhead and I/O wait times for repetitive web requests.

* **`opcache.memory_consumption=128`**
  Allocates 128MB of RAM specifically for the OPcache. For our standard Laravel deployments, this provides more than enough space to hold the compiled codebase in memory, ensuring rapid execution.
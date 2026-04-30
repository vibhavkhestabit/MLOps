#!/bin/bash
set -e

echo "================================================"
echo "Generating MySQL Read-Optimized Configuration..."
echo "================================================"

# Create the optimized configuration file
cat <<EOF > optimization.cnf
[mysqld]
# --- READ-HEAVY OPTIMIZATIONS ---

# 1. Connection Pool
max_connections = 500
thread_cache_size = 100

# 2. InnoDB Buffer Pool (The most critical setting for read speed)
# Usually set to 60-80% of total server RAM. We use 1GB for this local test.
innodb_buffer_pool_size = 1G
innodb_buffer_pool_instances = 1

# 3. I/O Threads (Increase for heavy concurrent reads)
innodb_read_io_threads = 8
innodb_write_io_threads = 4

# 4. Fast Query Tuning
innodb_flush_log_at_trx_commit = 2 
innodb_thread_concurrency = 0

# Note: Query Cache is deprecated/removed in MySQL 8.0+, 
# relying purely on the optimized InnoDB Buffer Pool instead.
EOF

# Move it to the system directory (requires sudo)
echo "Applying configuration to MySQL..."
sudo cp optimization.cnf /etc/mysql/conf.d/optimization.cnf
sudo systemctl restart mysql

echo "================================================"
echo "[SUCCESS] MySQL is now tuned for read-heavy workloads!"
echo "================================================"
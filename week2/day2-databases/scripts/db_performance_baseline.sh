#!/bin/bash

# Script: db_performance_baseline.sh
# Description: Runs synthetic benchmarking (1000 ops) to establish database performance baselines.
# Author: Vibhav Khaneja
# Date: 2026-04-23

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
REPORT_FILE="${LOG_DIR}/db_performance_baseline.txt"
TMP_DIR="/tmp/db_bench"

mkdir -p "$LOG_DIR" "$TMP_DIR"

# Credentials
PG_USER="postgres"
MYSQL_PASS="RootP@ssw0rd123"
MONGO_PASS="AdminP@ssw0rd123"

echo "DATABASE PERFORMANCE BASELINE" | tee "$REPORT_FILE"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$REPORT_FILE"
echo "========================================" | tee -a "$REPORT_FILE"

# Helper function to calculate and print metrics
print_metrics() {
    local op=$1
    local ms=$2
    local total_queries=1000
    
    # Avoid division by zero if it runs under 1ms
    if [ "$ms" -eq 0 ]; then ms=1; fi 
    
    local sec=$(echo "scale=2; $ms / 1000" | bc)
    local qps=$(echo "$total_queries * 1000 / $ms" | bc)
    local avg=$(echo "scale=2; $ms / $total_queries" | bc)
    
    # Format nicely
    if [[ "$sec" == .* ]]; then sec="0$sec"; fi
    if [[ "$avg" == .* ]]; then avg="0$avg"; fi
    
    # but escapes the variable capture trap.
    echo "$op: 1000 queries in ${sec}s ($qps qps)" | tee -a "$REPORT_FILE" >&2
    
    # Echo ONLY the numeric average to stdout so the variable can do math with it
    echo "$avg"
}

# --- 1. PostgreSQL Benchmark ---
bench_postgres() {
    echo "PostgreSQL (testdb):" | tee -a "$REPORT_FILE"
    sudo -u "$PG_USER" psql -d testdb -c "DROP TABLE IF EXISTS perf_test; CREATE TABLE perf_test (id INT, val TEXT);" >/dev/null 2>&1

    # Generate Query Files
    > "$TMP_DIR/pg_ins.sql"; > "$TMP_DIR/pg_sel.sql"; > "$TMP_DIR/pg_upd.sql"
    for i in {1..1000}; do 
        echo "INSERT INTO perf_test (id, val) VALUES ($i, 'data');" >> "$TMP_DIR/pg_ins.sql"
        echo "SELECT * FROM perf_test WHERE id = $i;" >> "$TMP_DIR/pg_sel.sql"
        echo "UPDATE perf_test SET val = 'updated' WHERE id = $i;" >> "$TMP_DIR/pg_upd.sql"
    done

    # Execute & Time INSERT
    start=$(date +%s%3N)
    sudo -u "$PG_USER" psql -d testdb -f "$TMP_DIR/pg_ins.sql" >/dev/null 2>&1
    end=$(date +%s%3N)
    avg_ins=$(print_metrics "INSERT" $((end - start)))

    # Execute & Time SELECT
    start=$(date +%s%3N)
    sudo -u "$PG_USER" psql -d testdb -f "$TMP_DIR/pg_sel.sql" >/dev/null 2>&1
    end=$(date +%s%3N)
    avg_sel=$(print_metrics "SELECT" $((end - start)))

    # Execute & Time UPDATE
    start=$(date +%s%3N)
    sudo -u "$PG_USER" psql -d testdb -f "$TMP_DIR/pg_upd.sql" >/dev/null 2>&1
    end=$(date +%s%3N)
    avg_upd=$(print_metrics "UPDATE" $((end - start)))

    total_avg=$(echo "scale=2; ($avg_ins + $avg_sel + $avg_upd) / 3" | bc)
    if [[ "$total_avg" == .* ]]; then total_avg="0$total_avg"; fi
    echo "Avg query time: ${total_avg}ms" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
}

# --- 2. MySQL Benchmark ---
bench_mysql() {
    echo "MySQL (appdb):" | tee -a "$REPORT_FILE"
    sudo mysql -u root -p"$MYSQL_PASS" -e "USE appdb; DROP TABLE IF EXISTS perf_test; CREATE TABLE perf_test (id INT PRIMARY KEY, val VARCHAR(50));" 2>/dev/null

    # Generate Query Files
    > "$TMP_DIR/my_ins.sql"; > "$TMP_DIR/my_sel.sql"; > "$TMP_DIR/my_upd.sql"
    for i in {1..1000}; do 
        echo "INSERT INTO perf_test (id, val) VALUES ($i, 'data');" >> "$TMP_DIR/my_ins.sql"
        echo "SELECT * FROM perf_test WHERE id = $i;" >> "$TMP_DIR/my_sel.sql"
        echo "UPDATE perf_test SET val = 'updated' WHERE id = $i;" >> "$TMP_DIR/my_upd.sql"
    done

    # Execute & Time
    start=$(date +%s%3N)
    sudo mysql -u root -p"$MYSQL_PASS" appdb < "$TMP_DIR/my_ins.sql" 2>/dev/null
    end=$(date +%s%3N)
    avg_ins=$(print_metrics "INSERT" $((end - start)))

    start=$(date +%s%3N)
    sudo mysql -u root -p"$MYSQL_PASS" appdb < "$TMP_DIR/my_sel.sql" 2>/dev/null
    end=$(date +%s%3N)
    avg_sel=$(print_metrics "SELECT" $((end - start)))

    start=$(date +%s%3N)
    sudo mysql -u root -p"$MYSQL_PASS" appdb < "$TMP_DIR/my_upd.sql" 2>/dev/null
    end=$(date +%s%3N)
    avg_upd=$(print_metrics "UPDATE" $((end - start)))

    total_avg=$(echo "scale=2; ($avg_ins + $avg_sel + $avg_upd) / 3" | bc)
    if [[ "$total_avg" == .* ]]; then total_avg="0$total_avg"; fi
    echo "Avg query time: ${total_avg}ms" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
}

# --- 3. MongoDB Benchmark ---
bench_mongo() {
    echo "MongoDB (appdb):" | tee -a "$REPORT_FILE"
    
    # We use a JS script executed inside mongosh to measure exact operation times
    cat << 'EOF' > "$TMP_DIR/mongo_bench.js"
    db = db.getSiblingDB('appdb');
    db.perf_test.drop();
    
    var start = new Date();
    for(var i=1; i<=1000; i++) { db.perf_test.insertOne({_id: i, val: 'data'}); }
    var end = new Date();
    print("INS_MS:" + (end - start));
    
    start = new Date();
    for(var i=1; i<=1000; i++) { db.perf_test.findOne({_id: i}); }
    end = new Date();
    print("SEL_MS:" + (end - start));
    
    start = new Date();
    for(var i=1; i<=1000; i++) { db.perf_test.updateOne({_id: i}, {$set: {val: 'updated'}}); }
    end = new Date();
    print("UPD_MS:" + (end - start));
EOF

    # Execute and parse results
    local results=$(mongosh appdb -u admin -p "$MONGO_PASS" --authenticationDatabase "admin" --quiet "$TMP_DIR/mongo_bench.js" 2>/dev/null)
    
    local ins_ms=$(echo "$results" | grep "INS_MS" | cut -d: -f2)
    local sel_ms=$(echo "$results" | grep "SEL_MS" | cut -d: -f2)
    local upd_ms=$(echo "$results" | grep "UPD_MS" | cut -d: -f2)

    avg_ins=$(print_metrics "insert" "$ins_ms")
    avg_sel=$(print_metrics "find" "$sel_ms")
    avg_upd=$(print_metrics "update" "$upd_ms")

    total_avg=$(echo "scale=2; ($avg_ins + $avg_sel + $avg_upd) / 3" | bc)
    if [[ "$total_avg" == .* ]]; then total_avg="0$total_avg"; fi
    echo "Avg operation time: ${total_avg}ms" | tee -a "$REPORT_FILE"
}

echo "Generating test queries and benchmarking... (This will take a few seconds)"
bench_postgres
bench_mysql
bench_mongo

# Cleanup temp files
rm -rf "$TMP_DIR"
echo "========================================" | tee -a "$REPORT_FILE"
echo "Baseline completed and saved to logs."
#!/bin/bash
# ==============================================================================
# Script Name: load_test_runner.sh
# Description: Automated load testing suite for all application stacks.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/load_testing"
mkdir -p "$LOG_DIR"

echo "========================================================"
echo "Starting Comprehensive Load Tests - $(date +'%Y-%m-%d %H:%M:%S')"
echo "========================================================"

# Function to run Apache Bench (ab)
run_ab_test() {
    local STACK_NAME=$1
    local URL=$2
    local OUTPUT_FILE="$LOG_DIR/${STACK_NAME}_apache_bench.txt"
    
    echo -e "\n--- Testing $STACK_NAME ($URL) ---" | tee -a "$OUTPUT_FILE"
    echo "Running 10,000 requests with 100 concurrent users..." | tee -a "$OUTPUT_FILE"
    
    # Run the test and append output to the file
    ab -n 10000 -c 100 "$URL" >> "$OUTPUT_FILE" 2>&1
    
    echo "Test complete. Results saved to $OUTPUT_FILE"
}

# Ensure Nginx is running before we hammer it
if ! systemctl is-active --quiet nginx; then
    echo "ERROR: Nginx is not running! Start it before load testing."
    exit 1
fi

# Run the tests! (Note: Testing the /api/health endpoints to simulate backend API load)
# Using http:// instead of https:// for local testing to avoid SSL overhead skewing backend results
run_ab_test "stack1" "http://127.0.0.1:3000/api/health"
run_ab_test "stack2" "http://127.0.0.1:8000/api/health"
run_ab_test "stack3" "http://127.0.0.1:8003/api/health"

echo -e "\n========================================================"
echo "All Load Tests Completed Successfully!"
echo "Review the results in: $LOG_DIR"
echo "Look for 'Requests per second' and 'Failed requests'."
echo "========================================================"
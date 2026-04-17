#!/bin/bash

# Script: performance_baseline.sh
# Description: Captures a 60-second baseline of CPU, Mem, Disk, and Network health.
# Author: Vibhav Khaneja

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="${REPORT_DIR}/performance_baseline.txt"

# 1. Pre-Flight Check: Ensure the required diagnostic tools are installed
if ! command -v iostat &> /dev/null; then
    echo "Installing required 'sysstat' performance tools..."
    sudo apt-get update -y > /dev/null
    sudo apt-get install sysstat -y > /dev/null
fi

echo "Starting 60-Second Performance Baseline Capture..."
echo "Please wait. The system is recording 12 samples at 5-second intervals..."

# Write Headers
echo "========== SYSTEM PERFORMANCE BASELINE ==========" > "$REPORT_FILE"
echo "Timestamp: $(date)" >> "$REPORT_FILE"

# 2. Instant Metrics (Load & Processors)
echo -e "\n[1] SYSTEM LOAD & PROCESSES" >> "$REPORT_FILE"
uptime >> "$REPORT_FILE"
echo "Total Active Processes: $(ps aux | wc -l)" >> "$REPORT_FILE"

# 3. Top Consumers (Who is eating the CPU right now?)
echo -e "\n[2] TOP 5 RESOURCE CONSUMERS" >> "$REPORT_FILE"
# Sort by CPU usage, grab the top 6 lines (1 header + 5 processes)
ps -eo pid,user,cmd,%cpu,%mem --sort=-%cpu | head -n 6 >> "$REPORT_FILE"

# 4. 60-Second Telemetry (CPU & Memory)
echo -e "\n[3] 60-SECOND TELEMETRY (CPU & MEMORY)" >> "$REPORT_FILE"
echo "Analyzing 12 samples..." >> "$REPORT_FILE"

# Run vmstat for 12 loops (5 seconds each) and pipe it into 'awk' to calculate Averages and Peaks
vmstat 5 12 | awk '
NR>2 {
    cpu_used = $13 + $14
    cpu_total += cpu_used
    if (cpu_used > cpu_peak) cpu_peak = cpu_used

    mem_free += $4
    mem_swpd += $3
    count++
}
END {
    print "-> CPU Average Usage : " int(cpu_total/count) "%"
    print "-> CPU Peak Usage    : " int(cpu_peak) "%"
    print "-> Mem Average Free  : " int(mem_free/count/1024) " MB"
    print "-> Mem Average Swap  : " int(mem_swpd/count/1024) " MB"
}' >> "$REPORT_FILE"

# 5. Disk I/O & Network
echo -e "\n[4] HARD DRIVE LATENCY (iostat)" >> "$REPORT_FILE"
iostat -x 1 1 | awk 'NR>2 {print}' >> "$REPORT_FILE"

echo -e "\n[5] NETWORK THROUGHPUT" >> "$REPORT_FILE"
# Capture network bytes transmitted and received
cat /proc/net/dev | grep -E "eth0|enp|wlan" | awk '{print $1 " Received: " int($2/1024/1024) " MB | Transmitted: " int($10/1024/1024) " MB"}' >> "$REPORT_FILE"

echo "=================================================" >> "$REPORT_FILE"
echo "Capture Complete! Report saved to $REPORT_FILE"
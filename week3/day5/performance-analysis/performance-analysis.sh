#!/bin/bash

REPORT="performance-report.txt"

echo "Docker Performance Report" > $REPORT
echo "Generated: $(date)" >> $REPORT
echo "" >> $REPORT

echo "=== IMAGE SIZES ===" >> $REPORT
docker images >> $REPORT

echo "" >> $REPORT
echo "=== CONTAINER STATS ===" >> $REPORT
docker stats --no-stream >> $REPORT

echo "" >> $REPORT
echo "=== SYSTEM DF ===" >> $REPORT
docker system df >> $REPORT

echo "" >> $REPORT
echo "=== RUNNING CONTAINERS ===" >> $REPORT
docker ps >> $REPORT

echo "Report generated: $REPORT"
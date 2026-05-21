#!/bin/bash

REPORT_DIR="./reports/trivy"
DATE=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$REPORT_DIR/scan-report-$DATE.txt"

mkdir -p "$REPORT_DIR"

echo "========== DOCKER IMAGE SECURITY SCAN ==========" > "$REPORT_FILE"
echo "Scan Date: $(date)" >> "$REPORT_FILE"
echo "===============================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Get all local images
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")

for IMAGE in $IMAGES; do
    echo "Scanning: $IMAGE"
    
    echo "Scanning: $IMAGE" >> "$REPORT_FILE"
    echo "----------------------------------------" >> "$REPORT_FILE"

    trivy image \
    --severity CRITICAL,HIGH \
    --no-progress \
    "$IMAGE" >> "$REPORT_FILE" 2>&1

    echo "" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
done

echo ""
echo "Scan completed."
echo "Report saved to: $REPORT_FILE"

echo ""
echo "========== VULNERABILITY SUMMARY =========="

grep -A 2 "Total:" "$REPORT_FILE" || echo "No vulnerabilities found"

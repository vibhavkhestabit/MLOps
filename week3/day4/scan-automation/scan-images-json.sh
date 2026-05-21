#!/bin/bash

REPORT_DIR="./reports/trivy-json"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p "$REPORT_DIR"

IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")

for IMAGE in $IMAGES; do
    SAFE_NAME=$(echo "$IMAGE" | tr '/:' '_')

    echo "Scanning JSON report for: $IMAGE"

    trivy image \
    --severity HIGH,CRITICAL \
    --format json \
    --output "$REPORT_DIR/${SAFE_NAME}_$DATE.json" \
    "$IMAGE"
done

echo "JSON scans completed."

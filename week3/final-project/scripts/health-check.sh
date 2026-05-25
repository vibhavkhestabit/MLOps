#!/bin/bash

echo "=================================="
echo "Docker Compose Status"
echo "=================================="

docker compose ps

echo ""
echo "=================================="
echo "Container Health"
echo "=================================="

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=================================="
echo "Resource Usage"
echo "=================================="

docker stats --no-stream

echo ""
echo "=================================="
echo "Health Check Completed"
echo "=================================="
#!/bin/bash

echo "=================================="
echo "Stopping Existing Containers"
echo "=================================="

docker compose down

echo ""
echo "=================================="
echo "Building All Services"
echo "=================================="

docker compose build

echo ""
echo "=================================="
echo "Starting Containers"
echo "=================================="

docker compose up -d

echo ""
echo "=================================="
echo "Running Containers"
echo "=================================="

docker compose ps

echo ""
echo "=================================="
echo "Build & Deployment Completed"
echo "=================================="
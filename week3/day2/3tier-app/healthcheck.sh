#!/bin/sh
# healthcheck.sh — 3-tier backend (Node.js + Express)
# Checks if the API responds with HTTP 200

wget -qO- http://localhost:3000/health > /dev/null 2>&1

if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi
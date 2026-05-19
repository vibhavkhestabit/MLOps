#!/bin/sh
# healthcheck.sh — MERN backend (Express + MongoDB)
# Checks API response AND that MongoDB reports as connected
 
RESPONSE=$(wget -qO- http://localhost:5000/health 2>/dev/null)
 
echo "$RESPONSE" | grep -q '"database":"connected"'
 
if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi
 
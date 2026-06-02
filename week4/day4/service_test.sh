#!/bin/bash

set -euo pipefail

SERVICE="${1:-}"

if [ -z "${SERVICE}" ]; then
    echo "Usage: $0 <service-name>"
    echo
    kubectl get svc
    exit 1
fi

echo "================================="
echo "SERVICE TEST : ${SERVICE}"
echo "================================="
echo

echo "=== Service Details ==="
kubectl get svc "${SERVICE}" -o wide

echo
echo "=== Endpoints ==="
kubectl get endpoints "${SERVICE}" -o wide

echo
echo "=== DNS + HTTP Test ==="

kubectl run svc-test \
  --rm -i \
  --restart=Never \
  --image=busybox:1.36 \
  -- sh -c "
echo 'DNS:'
nslookup ${SERVICE}

echo
echo 'HTTP:'
wget -qO- http://${SERVICE}
"
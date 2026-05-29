#!/bin/bash
# pod_debug.sh - Debug helper for Kubernetes pods

set -euo pipefail

POD_NAME="${1:-}"
NAMESPACE="${2:-default}"

if [ -z "${POD_NAME}" ]; then
    echo "Usage: $0 <pod-name> [namespace]"
    echo ""
    echo "Available pods:"
    kubectl get pods -n "${NAMESPACE}" --no-headers | awk '{print " - " $1 " (" $3 ")"}'
    exit 1
fi

echo "========================================"
echo " POD DEBUG: ${POD_NAME}"
echo " Namespace: ${NAMESPACE}"
echo "========================================"
echo ""

# Basic pod info
echo "=== POD STATUS ==="
kubectl get pod "${POD_NAME}" -n "${NAMESPACE}" -o wide
echo ""

# Container info
echo "=== CONTAINERS ==="
kubectl get pod "${POD_NAME}" -n "${NAMESPACE}" \
    -o jsonpath='{range .spec.containers[*]}{.name}{"\t"}{.image}{"\n"}{end}'
echo ""

# Pod conditions
echo "=== CONDITIONS ==="
kubectl get pod "${POD_NAME}" -n "${NAMESPACE}" \
    -o jsonpath='{range .status.conditions[*]}{.type}{": "}{.status}{" ("}{.reason}{")"}{"\n"}{end}'
echo ""

# Events
echo "=== RECENT EVENTS ==="
kubectl get events -n "${NAMESPACE}" \
    --field-selector involvedObject.name="${POD_NAME}" \
    --sort-by='.lastTimestamp' | tail -10
echo ""

# Logs
echo "=== RECENT LOGS ==="

CONTAINERS=$(kubectl get pod "${POD_NAME}" -n "${NAMESPACE}" \
    -o jsonpath='{.spec.containers[*].name}')

for CONTAINER in ${CONTAINERS}; do
    echo "--- Container: ${CONTAINER} ---"

    kubectl logs "${POD_NAME}" \
        -n "${NAMESPACE}" \
        -c "${CONTAINER}" \
        --tail=20 2>/dev/null || echo "No logs available"

    echo ""
done

# Resource usage
echo "=== RESOURCE USAGE ==="
kubectl top pod "${POD_NAME}" -n "${NAMESPACE}" 2>/dev/null || \
    echo "Metrics not available"
echo ""

echo "========================================"
echo "Useful Debug Commands:"
echo " kubectl describe pod ${POD_NAME} -n ${NAMESPACE}"
echo " kubectl logs ${POD_NAME} -n ${NAMESPACE} -f"
echo " kubectl exec -it ${POD_NAME} -n ${NAMESPACE} -- /bin/sh"
echo "========================================"
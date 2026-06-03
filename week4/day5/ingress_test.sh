#!/bin/bash
# ingress_test.sh - Test ingress configuration

set -uo pipefail

echo "=========================================="
echo "INGRESS TEST SUITE"
echo "=========================================="
echo ""

echo "=== Ingress Controller ==="
kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller
echo ""

echo "=== Ingress Resources ==="
kubectl get ingress
echo ""

MINIKUBE_IP=$(minikube ip 2>/dev/null || echo "localhost")

echo "Minikube IP: ${MINIKUBE_IP}"
echo ""

echo "=== Testing Ingress Rules ==="

for INGRESS in $(kubectl get ingress -o jsonpath='{.items[*].metadata.name}')
do
    echo ""
    echo "--- Ingress: ${INGRESS} ---"

    HOSTS=$(kubectl get ingress "${INGRESS}" -o jsonpath='{.spec.rules[*].host}')

    if [ -z "${HOSTS}" ]; then

        PATHS=$(kubectl get ingress "${INGRESS}" \
            -o jsonpath='{.spec.rules[0].http.paths[*].path}')

        for PATH in ${PATHS}
        do
            URL="http://${MINIKUBE_IP}${PATH}"

            STATUS=$(curl -s -L -o /dev/null \
                -w "%{http_code}" \
                "${URL}" 2>/dev/null)

            if [ -z "${STATUS}" ] || [ "${STATUS}" = "000" ]; then
                STATUS="FAIL"
            fi

            echo "${URL} -> ${STATUS}"
        done

    else

        for HOST in ${HOSTS}
        do
            STATUS=$(curl -s -L -o /dev/null \
                -w "%{http_code}" \
                -H "Host: ${HOST}" \
                "http://${MINIKUBE_IP}/" 2>/dev/null)

            if [ -z "${STATUS}" ] || [ "${STATUS}" = "000" ]; then
                STATUS="FAIL"
            fi

            echo "http://${HOST}/ -> ${STATUS}"
        done

    fi

done

echo ""
echo "=========================================="
echo "Ingress Controller Logs (last 10 lines)"
echo "=========================================="

CONTROLLER_POD=$(kubectl get pod -n ingress-nginx \
-l app.kubernetes.io/component=controller \
-o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -n "${CONTROLLER_POD}" ]; then
    kubectl logs -n ingress-nginx "${CONTROLLER_POD}" --tail=10
else
    echo "Could not locate ingress controller pod"
fi

echo ""
echo "=========================================="
echo "Ingress Test Complete"
echo "=========================================="
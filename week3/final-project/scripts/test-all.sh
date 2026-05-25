#!/bin/bash

echo "=================================="
echo "Testing Microservices"
echo "=================================="

echo ""
echo "API Gateway:"
curl -s localhost:5000/health

echo ""
echo ""
echo "User Service:"
curl -s localhost:8010/health

echo ""
echo ""
echo "Product Service:"
curl -s localhost:8011/health

echo ""
echo ""
echo "Order Service:"
curl -s localhost:8012/health

echo ""
echo ""
echo "Gateway Routing Tests"

echo ""
echo "Users Route:"
curl -s localhost:5000/api/users/users

echo ""
echo ""
echo "Products Route:"
curl -s localhost:5000/api/products/products

echo ""
echo ""
echo "Orders Route:"
curl -s localhost:5000/api/orders/orders

echo ""
echo ""
echo "=================================="
echo "All Tests Completed"
echo "=================================="
#!/bin/bash

RESOURCE_GROUP="devops-lab-rg"
VM_NAME="devops-vm"

echo "================================="
echo " Azure VM Information"
echo "================================="

az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  -o table

echo ""
echo "Public IP:"

az vm list-ip-addresses \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" \
  -o tsv

echo ""
echo "Checking Nginx Port 80 Rule..."

az network nsg rule list \
  --resource-group $RESOURCE_GROUP \
  --nsg-name devops-vmNSG \
  --query "[?destinationPortRange=='80']" \
  -o table
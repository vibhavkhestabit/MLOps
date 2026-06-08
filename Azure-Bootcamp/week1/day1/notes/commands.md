# Week 1 - Day 1 Commands

## Verify Azure CLI Installation

```bash
az version
```

---

## Login to Azure

```bash
az login
```

---

## View Current Account Information

```bash
az account show
```

---

## List Available Azure Regions

```bash
az account list-locations -o table
```

---

## Create Resource Group

```bash
az group create \
  --name devops-lab-rg \
  --location centralindia
```

---

## List Resource Groups

```bash
az group list -o table
```

---

## Azure Setup Automation Script

```bash
#!/bin/bash

RESOURCE_GROUP="devops-lab-rg"
LOCATION="centralindia"

echo "=================================="
echo "Azure Environment Setup"
echo "=================================="

echo ""
echo "Checking Azure CLI..."

if ! command -v az &> /dev/null
then
    echo "Azure CLI not installed"
    exit 1
fi

echo "Azure CLI found"
echo ""

echo "Current Account:"
az account show --output table

echo ""
echo "Creating Resource Group..."

az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION \
  --output table

echo ""
echo "Listing Resource Groups..."

az group list --output table

echo ""
echo "Setup Completed Successfully"
```

---

## Make Script Executable

```bash
chmod +x scripts/azure_setup.sh
```

---

## Execute Script

```bash
./scripts/azure_setup.sh
```

---

## Cleanup Resource Group (Optional)

```bash
az group delete \
  --name devops-lab-rg \
  --yes
```

Note:
Deleting a Resource Group deletes all resources contained within it.

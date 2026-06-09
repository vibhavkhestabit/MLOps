# Day 2 - Virtual Machines & Networking

## Exercise 2.1 - Create Virtual Network and Subnet

```bash
az network vnet create \
  --resource-group devops-lab-rg \
  --name devops-vnet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name web-subnet \
  --subnet-prefix 10.0.1.0/24
```

Verify VNet:

```bash
az network vnet list \
  --resource-group devops-lab-rg \
  -o table
```

Verify Subnet:

```bash
az network vnet subnet list \
  --resource-group devops-lab-rg \
  --vnet-name devops-vnet \
  -o table
```

---

## Exercise 2.2 - Create Ubuntu Virtual Machine

```bash
az vm create \
  --resource-group devops-lab-rg \
  --name devops-vm \
  --image Ubuntu2204 \
  --size Standard_B2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys
```

Verify VM:

```bash
az vm list \
  --resource-group devops-lab-rg \
  -o table
```

---

## Exercise 2.3 - Verify Network Security Group

List NSGs:

```bash
az network nsg list \
  --resource-group devops-lab-rg \
  -o table
```

List NSG Rules:

```bash
az network nsg rule list \
  --resource-group devops-lab-rg \
  --nsg-name devops-vmNSG \
  -o table
```

---

## Exercise 2.4 - Connect via SSH

```bash
ssh azureuser@<PUBLIC_IP>
```

Useful Linux Verification Commands:

```bash
whoami
hostname
pwd
free -h
df -h
```

Disconnect:

```bash
exit
```

---

## Exercise 2.5 - Install and Expose Nginx

SSH into VM:

```bash
ssh azureuser@<PUBLIC_IP>
```

Update packages:

```bash
sudo apt update
```

Install Nginx:

```bash
sudo apt install nginx -y
```

Check Service:

```bash
systemctl status nginx
```

Test Locally:

```bash
curl localhost
```

Exit VM:

```bash
exit
```

Open Port 80:

```bash
az vm open-port \
  --resource-group devops-lab-rg \
  --name devops-vm \
  --port 80
```

Verify Rule:

```bash
az network nsg rule list \
  --resource-group devops-lab-rg \
  --nsg-name devops-vmNSG \
  -o table
```

Open Browser:

```text
http://<PUBLIC_IP>
```

---

## Exercise 2.6 - Resource Inspection

List all Azure resources created automatically:

```bash
az resource list \
  --resource-group devops-lab-rg \
  -o table
```

Show VM details:

```bash
az vm show \
  --resource-group devops-lab-rg \
  --name devops-vm \
  --show-details \
  -o table
```

Get Public IP:

```bash
az vm list-ip-addresses \
  --resource-group devops-lab-rg \
  --name devops-vm \
  -o table
```

---

## Cleanup Commands (IMPORTANT)

Stop VM:

```bash
az vm stop \
  --resource-group devops-lab-rg \
  --name devops-vm
```

Start VM:

```bash
az vm start \
  --resource-group devops-lab-rg \
  --name devops-vm
```

Deallocate VM (recommended when not using):

```bash
az vm deallocate \
  --resource-group devops-lab-rg \
  --name devops-vm
```

Delete Entire Resource Group:

```bash
az group delete \
  --name devops-lab-rg \
  --yes \
  --no-wait
```

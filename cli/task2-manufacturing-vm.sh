#!/bin/bash
set -e
# Task 2: ManufacturingVnet + ManufacturingVM (Windows Server 2025)
RG=az104-rg5
LOC=eastus

read -s -p "VM admin password: " PASS
echo

# Network first
az network vnet create --resource-group $RG --name ManufacturingVnet --location $LOC --address-prefixes 172.16.0.0/16 --subnet-name Manufacturing --subnet-prefixes 172.16.0.0/24 -o none

# VM in the Manufacturing subnet
az vm create --resource-group $RG --name ManufacturingVM --location $LOC \
--image MicrosoftWindowsServer:WindowsServer:2025-datacenter-g2:latest \
--size Standard_D2s_v3 --security-type Standard \
--admin-username localadmin --admin-password "$PASS" \
--vnet-name ManufacturingVnet --subnet Manufacturing \
--public-ip-address "" --nsg-rule NONE \
--storage-sku Standard_LRS \
--no-wait

echo "ManufacturingVM deployment started (running in background)"
#!/bin/bash
set -e
# Task 1: CoreServicesVnet + CoreServicesVM (Windows Server 2025)
RG=az104-rg5
LOC=eastus

# Ask for the VM password (never store passwords in scripts/GitHub)
read -s -p "VM admin password: " PASS
echo

az group create --name $RG --location $LOC -o table

# Network first
az network vnet create --resource-group $RG --name CoreServicesVnet --location $LOC --address-prefixes 10.0.0.0/16 --subnet-name Core --subnet-prefixes 10.0.0.0/24 -o table

# VM in the Core subnet, no public IP, Standard HDD, Standard security type
az vm create --resource-group $RG --name CoreServicesVM --location $LOC \
--image MicrosoftWindowsServer:WindowsServer:2025-datacenter-g2:latest \
--size Standard_D2s_v3 --security-type Standard \
--admin-username localadmin --admin-password "$PASS" \
--vnet-name CoreServicesVnet --subnet Core \
--public-ip-address "" --nsg-rule NONE \
--storage-sku Standard_LRS \
--no-wait

echo "VM deployment started (running in background)"
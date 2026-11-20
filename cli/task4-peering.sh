#!/bin/bash
set -e
# Task 4: Bidirectional VNet peering between CoreServicesVnet and ManufacturingVnet
RG=az104-rg5

# Core -> Manufacturing
az network vnet peering create --resource-group $RG \
--name CoreServicesVnet-to-ManufacturingVnet \
--vnet-name CoreServicesVnet --remote-vnet ManufacturingVnet \
--allow-vnet-access --allow-forwarded-traffic -o none

# Manufacturing -> Core
az network vnet peering create --resource-group $RG \
--name ManufacturingVnet-to-CoreServicesVnet \
--vnet-name ManufacturingVnet --remote-vnet CoreServicesVnet \
--allow-vnet-access --allow-forwarded-traffic -o none

# Verify both sides
for VNET in CoreServicesVnet ManufacturingVnet; do
az network vnet peering list --resource-group $RG --vnet-name $VNET \
--query "[].{Name:name, State:peeringState, Sync:peeringSyncLevel}" -o table
done
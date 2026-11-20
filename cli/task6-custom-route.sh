#!/bin/bash
set -e
# Task 6: Perimeter subnet + route table sending traffic via a future NVA (10.0.1.7)
RG=az104-rg5
LOC=eastus

# Perimeter subnet for the future NVA
az network vnet subnet create --resource-group $RG --vnet-name CoreServicesVnet --name perimeter --address-prefixes 10.0.1.0/24 -o none

# Route table (no gateway route propagation)
az network route-table create --resource-group $RG --name rt-CoreServices --location $LOC --disable-bgp-route-propagation true -o none

# User-defined route: CoreServicesVnet traffic -> NVA
az network route-table route create --resource-group $RG --route-table-name rt-CoreServices \
--name PerimetertoCore --address-prefix 10.0.0.0/16 \
--next-hop-type VirtualAppliance --next-hop-ip-address 10.0.1.7 -o none

# Associate the route table with the Core subnet
az network vnet subnet update --resource-group $RG --vnet-name CoreServicesVnet --name Core --route-table rt-CoreServices -o none

# Verify
az network route-table route list --resource-group $RG --route-table-name rt-CoreServices \
--query "[].{Name:name, Prefix:addressPrefix, NextHop:nextHopType, NextHopIP:nextHopIpAddress}" -o table
az network vnet subnet show --resource-group $RG --vnet-name CoreServicesVnet --name Core --query "routeTable.id" -o tsv

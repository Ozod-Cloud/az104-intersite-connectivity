to me

#!/bin/bash
set -e
# Task 5: From inside ManufacturingVM, test RDP (3389) to CoreServicesVM over the peering
RG=az104-rg5

# Get CoreServicesVM private IP automatically (no hard-coding)
CORE_IP=$(az vm show -d --resource-group $RG --name CoreServicesVM --query privateIps -o tsv)
echo "CoreServicesVM private IP: $CORE_IP"

echo "Running Test-NetConnection inside ManufacturingVM (takes 1-2 minutes)..."
az vm run-command invoke --resource-group $RG --name ManufacturingVM \
--command-id RunPowerShellScript \
--scripts "Test-NetConnection $CORE_IP -Port 3389" \
--query "value[0].message" -o tsv


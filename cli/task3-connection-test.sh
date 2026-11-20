#!/bin/bash
set -e
# Task 3: Network Watcher connection troubleshoot CoreServicesVM -> ManufacturingVM:3389
RG=az104-rg5

# Connection troubleshoot needs the Network Watcher agent on the source VM
az vm extension set --resource-group $RG --vm-name CoreServicesVM --name NetworkWatcherAgentWindows --publisher Microsoft.Azure.NetworkWatcher -o none

echo "Running connectivity test (takes 1-3 minutes)..."
az network watcher test-connectivity --resource-group $RG \
--source-resource CoreServicesVM --dest-resource ManufacturingVM \
--dest-port 3389 --protocol Tcp \
--query "{Status:connectionStatus, ProbesSent:probesSent, ProbesFailed:probesFailed}" -o table

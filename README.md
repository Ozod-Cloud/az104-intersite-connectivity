# AZ-104 Lab 05 – Implement Intersite Connectivity (Azure CLI)

Connected two isolated VNets with VNet peering, tested connectivity with Network Watcher and Run Command, and added a user-defined route – all from Azure CLI scripts.

| Task | What I built | File |
|------|--------------|------|
| 1 | CoreServicesVnet (10.0.0.0/16) + CoreServicesVM (Windows Server 2025, no public IP) | cli/task1-core-vm.sh |
| 2 | ManufacturingVnet (172.16.0.0/16) + ManufacturingVM | cli/task2-manufacturing-vm.sh |
| 3 | Network Watcher connection troubleshoot (Unreachable before peering) | cli/task3-connection-test.sh |
| 4 | Bidirectional VNet peering (both sides Connected) | cli/task4-peering.sh |
| 5 | Test-NetConnection from inside ManufacturingVM via Run Command | cli/task5-run-command-test.sh |
| 6 | Perimeter subnet + route table rt-CoreServices (10.0.0.0/16 → NVA 10.0.1.7) | cli/task6-custom-route.sh |

## Key concepts
- VNets are isolated by default; peering requires non-overlapping address spaces
- Peering is two links – if only one side exists the state stays Initiated
- Peered traffic uses the Microsoft backbone, not the internet
- User-defined routes override system routes; route tables attach to subnets
- Network Watcher tests connectivity from Azure; Run Command tests from inside the VM

## Real-world issues I solved
- VM passwords are read with `read -s` so no secrets are stored in the public repo
- Added `set -e` after a failed VM create still printed a "success" message
- Cloud Shell session dropped during a long test – recovered by verifying resources still existed and pushing work to GitHub early
- Test-NetConnection returned TcpTestSucceeded False after peering was Connected. Troubleshooting: verified both peering links, then checked the VM instance view – the Azure VM Agent on CoreServicesVM was Not Ready, which also explained hanging extension installs and Run Command calls. Network config was correct; the issue was inside the guest VM.

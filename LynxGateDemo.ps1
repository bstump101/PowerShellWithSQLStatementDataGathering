# 1. PSHSummit2023Demo (LynxGate Demo)

# .Silent cls

# Install PSHSummit2023Demo (LynxGate Demo) Module on to Computer.

Install-Module PSHSummit2023Demo -Repository PowerShellRepository

# Import-Module PSHSummit2023Demo into current PowerShell Session.

Import-Module -Name PSHSummit2023Demo

# Get Cmdlets in PSHSummit2023Demo.

get-command -Module PSHSummit2023Demo

# Import Data into CatOperations Data Table.

Invoke-CatOperations

# Query data in CatOperations Data Table.

$CatOperations | ft -auto

# Create and Import Data into CatDeviceLog Data Table.

Invoke-CatDeviceLog

# Query data in CatDeviceLog Data Table.

$CatDeviceLog | ft -auto

# Create and Import Data into DeviceStatusTypes Data Table.

Invoke-DeviceStatusTypesTable

# Display Device Status Types Data Table.

$DeviceStatusTypes

# Check LynxGate Queue

Invoke-LynxGateQueueStatus

# Check LynxGate Interface

Invoke-LynxGateCOOPSBAInterface

# Display Complete Output

Invoke-LynxGateOutput

# -----------------------
# End of LynxGate Demo.
# -----------------------
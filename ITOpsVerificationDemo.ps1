# 1. ITOpsVerification Module

# .Silent cls

# Get available repositories.

Get-PSRepository

# Install ITOpsVerification module from internal PowerShell Repository.

Install-Module ITOpsVerification -Repository PowerShellRepository

# Import-Module ITOpsVerification into current PowerShell Session.

Import-Module -Name ITOpsVerification

# Get Cmdlets in ITOpsVerification.

Get-Command -Module ITOpsVerification | ?{$_.Name -like "Invoke-Lynx*"}

# ------------------------------
# End of ITOpsVerification Demo.
# ------------------------------
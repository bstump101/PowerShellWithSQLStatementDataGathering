# Programmer:	Bruce Stump
# Date:		3/20/2019
# Description:	Script that emails a LynxGate Status Report to IT Ops.  This script is executed by a scheduled task and
#		the Invoke-LynxGateStatusOutput is a custom module by Bruce Stump that generates the data.
#########################################################################################################################


#$mailTo = "bstump@tcunet.com"  # Email used for troubleshooting, use a comma to separate multiple emails.

$mailTo = "ITOperations@tcunet.com"
$mailFrom = "ITOpsVerification-LynxGate@tcunet.com"
$mailSubject = "LynxGate Status"

$mailLynxGateStatusReport = $(Invoke-LynxGateStatusOutput | Out-String)

$mailSmtpServer = "smtp1.tcu.ad.local"

Start-Sleep 5

Send-MailMessage -To $mailTo -From $mailFrom -Subject $mailSubject -Body $mailLynxGateStatusReport -SmtpServer $mailSmtpServer
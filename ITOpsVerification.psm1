<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	2/22/2019 11:39 AM
	 Created by:   	substump
	 Organization: 	TCU
	 Filename:     	ITOpsVerifications.psm1
	-------------------------------------------------------------------------
	 Module Name: ITOpsVerifications
	===========================================================================
#>

<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	2/22/2019 11:17 AM
	 Created by:   	substump
	 Organization: 	TCU
	 Filename:     	ITOpsVerifications.psm1
	===========================================================================
	.DESCRIPTION
		A module for various IT Operations Verifications
#>

function Invoke-LynxGateSandFStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
		{
			$LynxGateLongDurationTransaction = 'None'
			$LynxGateHighVolumeTransaction = 'None'
		}
	Process
	{
		$LynxGateData += (invoke-sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query "declare @date datetime;set @date = DATEDIFF(DD,0,GETDATE()-1);select top 300 OperationID,OperationDateTime,OperationAcquirer,OperationClass,OperationForcePostType,OperationResponseType,MemberNumber,Amount,SwitchDeviceID from CATOperations with (nolock) where OperationDateTime >= @date and StoreFwdStatus = 3 Order by OperationID asc")
		
		if ($LynxGateData.count -gt 150)
		{
			# Query dates of transactions.
			
			$LynxGateData | % {
				if ($_.OperationDateTime -lt (Get-Date).AddHours(-1))
				{
					$LynxGateLongDurationTransaction = 'Error:  Transactions have been stuck in queue for over an hour, Please investigate.  https://td-lynxweb-01.tcu.ad.local/CatWeb/DeviceStatus/DeviceStatusPge.aspx'
					Break;
				}
				
			}
			
			# Over 150 transactions in queue, send email.
			
			$LynxGateHighVolumeTransaction = "Warning:  High volume of transactions sitting in queue, please investigate - Transaction Count:  " + $LynxGateData.count + ' - https://td-lynxweb-01.tcu.ad.local/CatWeb/DeviceStatus/DeviceStatusPge.aspx'
			
		}
		else
		{
			$LynxGateStatus = "Lynxgate S&F queue is at " + $LynxGateData.count
		}
		
		$LynxGateOutput = @"
LynxGate Status
**************

$LynxGateStatus


LynxGate Warning ( > 150 Transactions in Queue )
************************************************

$LynxGateHighVolumeTransaction


LynxGate Error ( Transactions Stuck in Queue for Over an Hour )
**************************************************************

$LynxGateLongDurationTransaction

"@
		
		$LynxGateOutput
		}
	End
		{
		
		}
}

function Invoke-LynxGateStarInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$starHeader = @'


Star Interface
**************
'@
	}
	Process
	{
		$starInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-5)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 82 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		$starHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $starInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateXpHostInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

XP Host Interface
*****************

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 4 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateXp2ETPHostInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

XP2 ETP Host Interface
***********************

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 105 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateSBIssuerHostInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

SB Issuer Host Interface
****************************

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 6 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateXPCardMaintenanceInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

XP Card Maintenance Interface
******************************

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 9 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateSBXPAcqHostInterfaceStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

SB XP Acq Host Interface
*************************

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 80 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateCOOPSBIStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

COOP SBI
*********

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 103 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateCOOPSBAStatus
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{
		$xpHostHeader = @'

COOP SBA
*********

'@
	}
	Process
	{
		$xpHostInterfaceStatus = @'
			declare @date datetime
			set @date = DATEDIFF(DD,0,GETDATE()-15)
			SELECT top 1 [CATDeviceLog].[ID]
			,[CATDeviceLog].[DeviceID]
			,[CATDeviceLog].[DeviceStatus]
			,[DeviceStatusTypes].[Description]
			,[CATDeviceLog].[StatusDate]
			FROM [catlog].[dbo].[CATDeviceLog] with(nolock)
			inner join [cat].[dbo].[DeviceStatusTypes] on CATDeviceLog.DeviceStatus = DeviceStatusTypes.Type where deviceid = 104 -- replace "null" with device ID
			--and DeviceStatus in ('-1','2')  -- ("-1" Non-operational: No communication link) ("2" Operational: Communication link established)
			and StatusDate >= @date
			Order by statusdate desc
'@
		
		$xpHostHeader
		$(Invoke-Sqlcmd -ServerInstance td-lynxdb-01 -Database cat -Query $xpHostInterfaceStatus)
	}
	End
	{
		
	}
}

function Invoke-LynxGateStatusOutput
{
	[CmdletBinding(PositionalBinding = $true)]
	param ()
	
	Begin
	{

	}
	Process
	{
		Invoke-LynxGateSandFStatus
		
		Start-Sleep -Seconds 5

		Invoke-LynxGateStarInterfaceStatus
		
		Start-Sleep -Seconds 5

		Invoke-LynxGateXpHostInterfaceStatus

		Start-Sleep -Seconds 5

		Invoke-LynxGateSBXPAcqHostInterfaceStatus

		Start-Sleep -Seconds 5

		Invoke-LynxGateXp2ETPHostInterfaceStatus

		Start-Sleep -Seconds 5

		Invoke-LynxGateCOOPSBIStatus

		Start-Sleep -Seconds 5

		Invoke-LynxGateCOOPSBAStatus
	}
	End
	{
		
	}
}

function Invoke-IronMountainXtenderImportMailMessage
{
	[CmdletBinding()]
	param (
	)
	
	BEGIN
	{
		# Mail Variables
		
		$smtpServer = "smtp1.tcu.ad.local"
		$toAddress = "bstump@tcunet.com", "ITOperations@tcunet.com"
		$fromAddress = "ITOpsVerification-IronMountainXtenderImport@tcunet.com"
		$failSubject = "Iron Mountain Xtender Import Status - Failure - $env:COMPUTERNAME"
		$successSubject = "Iron Mountain Xtender Import Status - Success - $env:COMPUTERNAME"
		$successMessage = 'PLEASE NOTE:  This is a scheduled automated process for Iron Mountain Xtender Import Verification.'
	}
	PROCESS
	{
		$ironMountainInputFolder = Get-ChildItem D:\Xtender_Integrations\FTP_Downloads\Input\TCU -Recurse | Where-Object { $_.Name -like "DISC*.zip" } | Format-Table Name, LastWriteTime -AutoSize
		
		if (!$ironMountainInputFolder)
		{
			Send-MailMessage -To $toAddress -From $fromAddress -Subject $successSubject -Body $successMessage -SmtpServer $smtpServer
		}
		
		else
		{
			Send-MailMessage -To $toAddress -From $fromAddress -Subject $failSubject -Body $(Invoke-IronMountainXtenderImportStatus | Out-String) -SmtpServer $smtpServer
		}
	}
	END
	{
	}
}

function Invoke-IronMountainXtenderImportStatus
{
	[CmdletBinding()]
	param (
	)
	
	BEGIN
	{
	}
	
	PROCESS
	{
		"`nPLEASE NOTE:  This is a scheduled automated process for Iron Mountain Xtender Import Verification.`n`n"
		Get-ChildItem D:\Xtender_Integrations\FTP_Downloads\Working\TCU -Recurse | Where-Object { $_.Name -like "DISC*.zip" } | Format-Table Name, LastWriteTime -AutoSize
	}
	END
	{
	}
}


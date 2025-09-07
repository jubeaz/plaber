param ([string]$IFName)
    Write-HostVerbose "Disable-NetAdapter $IFName"
	Disable-NetAdapter -Name $IFName -Confirm:$false
    Write-HostVerbose "Enable-NetAdapter $IFName"
	Enable-NetAdapter -Name $IFName -Confirm:$false
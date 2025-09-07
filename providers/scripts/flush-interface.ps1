param ([string]$IFName)
    Write-Verbose "Disable-NetAdapter $IFName"
	Disable-NetAdapter -Name $IFName -Confirm:$false
    Write-Verbose "Enable-NetAdapter $IFName"
	Enable-NetAdapter -Name $IFName -Confirm:$false
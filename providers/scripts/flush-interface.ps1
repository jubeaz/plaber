param ([string]$IFName)
	Disable-NetAdapter -Name $IFName -Confirm:$false
	Enable-NetAdapter -Name $IFName -Confirm:$false
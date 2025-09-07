param ([string]$IFName, [string]$NetPrefix = $false)
	$interface = Get-NetIPAddress | Where-Object { $_.IPAddress -like $NetPrefix }
	$interfaceName = $interface.InterfaceAlias
	Rename-NetAdapter -Name $interfaceName -NewName $IFName
	#Disable-NetAdapter -Name $IFName -Confirm:$false
	#Enable-NetAdapter -Name $IFName -Confirm:$false
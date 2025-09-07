param ([string]$IFName, [string]$NetPrefix = $false)
	Write-Output "Renaming interface containing $NetPrefix to $IFName"
	$interface = Get-NetIPAddress | Where-Object { $_.IPAddress -like $NetPrefix }
	$interfaceName = $interface.InterfaceAlias
	Write-Output "Found $interfaceName"
	Rename-NetAdapter -Name $interfaceName -NewName $IFName
	#Disable-NetAdapter -Name $IFName -Confirm:$false
	#Enable-NetAdapter -Name $IFName -Confirm:$false
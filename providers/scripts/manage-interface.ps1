param (
    [Parameter(Mandatory)]
    [string]$NewName,

    [Parameter(Mandatory)]
    [int]$Metric,

    [Parameter(Mandatory)]
    [string]$NetPrefix
)

Write-Output "Renaming interface containing $NetPrefix to $NewName"
$interface = Get-NetIPAddress | Where-Object { $_.IPAddress -like $NetPrefix }
$interfaceName = $interface.InterfaceAlias
Write-Output "Found $interfaceName"
Rename-NetAdapter -Name $interfaceName -NewName $NewName
Set-NetIPInterface -InterfaceAlias $NewName -AutomaticMetric Disabled -InterfaceMetric $Metric
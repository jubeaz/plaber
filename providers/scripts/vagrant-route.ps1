
param (
    [Parameter(Mandatory)]
    [string]$IFName,

    [Parameter(Mandatory)]
    [string]$Destination
)
Write-Output "New-NetRoute -DestinationPrefix $Destination/32 -InterfaceAlias $IFName -NextHop $Destination -PolicyStore ActiveStore"
New-NetRoute -DestinationPrefix $Destination/32 -InterfaceAlias $IFName -NextHop $Destination -PolicyStore ActiveStore
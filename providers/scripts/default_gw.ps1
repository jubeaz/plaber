# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286
param (
    [Parameter(Mandatory)]
    [string]$IFName,

    [Parameter(Mandatory)]
    [int]$Metric,

    [Parameter(Mandatory)]
    [string]$Gateway
)

#route add 0.0.0.0 mask 0.0.0.0 $Gateway
#Remove-NetRoute -DestinationPrefix "0.0.0.0/0"  -Confirm:$false
Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue | Remove-NetRoute -Confirm:$false
Write-Output "Setting defaut route on $IFName to $Gateway"
New-NetRoute -InterfaceAlias $IFName -DestinationPrefix "0.0.0.0/0" -NextHop $Gateway -RouteMetric $Metric

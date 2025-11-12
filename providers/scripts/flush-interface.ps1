param (
    [Parameter(Mandatory)]
    [string]$IFName
)

Write-Output "Disable-NetAdapter $IFName"
Disable-NetAdapter -Name $IFName -Confirm:$false
Write-Output "Enable-NetAdapter $IFName"
Enable-NetAdapter -Name $IFName -Confirm:$false
# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286

param ([String] $Gateway, [string]$IFName)
 	#route add 0.0.0.0 mask 0.0.0.0 $Gateway
	Write-Output "Setting defaut route on $IFName to $Gateway"
	New-NetRoute -InterfaceAlias $IFName -DestinationPrefix "0.0.0.0/0" -NextHop $Gateway

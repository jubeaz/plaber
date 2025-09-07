# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286
param ([String] $if_name, [String] $ip, [String] $mask, [String] $gw)
    Write-Output "Set-FixedIP -IFName $IFName -IP $IP -Mask $Mask -Gateway $Gateway"
	if ($IFName -ne $false){
        if ( $false -eq $IP -or $false -eq $Mask ){
            Throw "Invalid Set-FixedIP call missing parameters"
        }
        if ($gw -ne $false){
		    Write-Output "netsh.exe interface ipv4 set address name=$IFName static $IP $Mask $Gateway" 
		    netsh.exe interface ipv4 set address name=$IFName static $IP $Mask $Gateway 
	    } else {
		Write-Output "netsh.exe interface ipv4 set address name=$IFName static $IP $Mask"
		netsh.exe interface ipv4 set address name=$IFName static $IP $Mask
	    }
	}
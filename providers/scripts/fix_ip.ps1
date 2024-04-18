# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286

param ([String] $if_name, [String] $ip, [String] $mask, [String] $gw)
	if ($gw -ne "None"){
		netsh.exe int ipv4 set address $if_name static $ip mask=$mask gateway=$gw 
	} else {
		netsh.exe int ipv4 set address "Ethernet 2" static $ip mask=$mask
	}


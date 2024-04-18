# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286

param ([String] $gw)
 	route add 0.0.0.0 mask 0.0.0.0 $gw


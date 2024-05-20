# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286

# eth0 = NAT
# eth1 = bridge
# eth 2 = internal


echo "      routes:"                                >> /etc/netplan/50-vagrant.yaml
echo "        - to: default"                        >> /etc/netplan/50-vagrant.yaml
echo "          via: $1"                            >> /etc/netplan/50-vagrant.yaml
echo "      nameservers:"                           >> /etc/netplan/50-vagrant.yaml
echo "          search: [mydomain, otherdomain]"    >> /etc/netplan/50-vagrant.yaml
echo "          addresses: [8.8.8.8]"               >> /etc/netplan/50-vagrant.yaml
sed -i "s/true/false/g" /etc/netplan/50-cloud-init.yaml
sed -i "s/^#PasswordAuthentication yes.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config 
reboot now
#systemctl restart sshd
#netplan apply
#sed -i "s/Name=eth.*/Name=eth0/g" /etc/systemd/network/80-dhcp.network
##echo "[Link]" >> /etc/systemd/network/80-dhcp.network
##echo  "Unmanaged=yes" >> /etc/systemd/network/80-dhcp.network
#
#sed -i "s/24/16/g" /etc/systemd/network/eth1.network
#echo "[Route]" >>  /etc/systemd/network/eth1.network
#echo "Gateway=$1" >>  /etc/systemd/network/eth1.network
#systemctl enable systemd-networkd
#systemctl restart systemd-networkd
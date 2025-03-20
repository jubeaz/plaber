# vmware bug to set the ip
# see : https://github.com/hashicorp/vagrant/issues/5000#issuecomment-258209286

# eth0 = NAT
# eth1 = bridge
# eth 2 = internal

echo "Set DHCP only on NAT interface (eth0)"
sed -i '/Name=en.*/d' /etc/systemd/network/80-dhcp.network
sed -i 's/Name=eth.*/Name=eth0/g' /etc/systemd/network/80-dhcp.network
#echo '[Link]' >> /etc/systemd/network/80-dhcp.network
#echo  'Unmanaged=yes' >> /etc/systemd/network/80-dhcp.network

if [[ "$1" == "routed" ]]; then
    echo "Will use routed interface (eth1)"    
    sed -i 's/24/16/g' /etc/systemd/network/eth1.network
    echo "[Route]" >>  /etc/systemd/network/eth1.network
    echo "Gateway=$2" >>  /etc/systemd/network/eth1.network
fi
echo "Ensure Networkd is started"
systemctl enable systemd-networkd
systemctl restart systemd-networkd
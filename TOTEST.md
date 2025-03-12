
# for local only
essayer de voir si l'on peut creer un bridge sur un dummy qui permettrait de se passer du mode nat du firewall le probleme c'est que ca ne sortira pas sur le net.

donc si on veut sortir il faut un bridge sur le wlan. 
```
==> /etc/systemd/network/bridge.netdev <==
[NetDev]
Name=br0
Kind=bridge


==> /etc/systemd/network/bridge.network <==
[Match]
Name=br0

[Network]
DHCP=No

[Address]
Address=2001:db8:150:436c::2/64


==> /etc/systemd/network/dummy1.netdev <==
[NetDev]
Name=dummy1
Kind=dummy

==> /etc/systemd/network/dummy1.network <==
[Match]
Name=dummy1

[Network]
Bridge=br0
DHCP=No
```
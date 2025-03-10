# replication
```
Get-ADReplicationPartnerMetadata -Target rsc01.research.haas.local
Get-ADReplicationQueueOperation -Server rsc01.research.haas.local


Get-ADReplicationPartnerMetadata -Target corp-DC01,corp-DC02 -PartnerType Both -Partition Schema

Get replication partner status
repadmin /showrepl 	Get-ADReplicationPartnerMetadata
Get Inbound replication queue details
repadmin /queue 	Get-ADReplicationQueueOperation
Replicate specific AD objects between domain controllers
repadmin /replsingleobj 	Sync-ADObject
Get replication metadata of an AD object
repadmin /showobjmeta 	Get-ADReplicationAttributeMetadata
Shows highest committed USN
repadmin /showutdvec 	Get-ADReplicationUpToDatenessVectorTable
Displays ISTG details
repadmin /istg * 	Get-ADReplicationSite –filter * | Select InterSiteTopologyGenerator
List all the subnets in the forest
dsquery subnet 	Get-ADReplicationSubnet
List the AD sites in the domain
dsquery site 	Get-ADReplicationSite
```


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
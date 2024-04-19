# plaber


# vagrant
## build all  vms
```bash
vagrant up
```

## build all  vms
```bash
vagrant halt
```


## disable all buildint NAT interfaces
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage modifyvm $b --cableconnected1 off"; vboxmanage modifyvm $b  --cableconnected1 off; done
```


## start all vagrant box
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done
```



# ansible

## build
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-lab.yml
```

## enable 
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```


# to fix

## ansible
need to wait

```bash
TASK [windows_domain/laps/dc : Configure Password Properties] ******************************************
changed: [dc_haas]
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (3 retries left).
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (2 retries left).
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (1 retries left).
An exception occurred during task execution. To see the full traceback, use -vvv. The error was:    at Microsoft.ActiveDirectory.Management.Commands.ADCmdletBase`1.ProcessRecord()
fatal: [dc_weyland]: FAILED! => {"attempts": 3, "changed": false, "msg": "Unhandled exception while executing module: The FSMO role ownership could not be verified because its directory partition has not replicated successfully with at least one replication partner"}
```

## vagrant

## public / private interface
a server with a public IP does not have properly set network on
`private_network` interface

manual solution
```powershell
evil-winrm -i 192.168.2.101 -u vagrant -p vagrant
netsh.exe int ipv4 set address 'Ethernet 2' static 172.16.1.10 mask=255.255.255.0 gateway=172.16.1.254
```

## shutdown on acpipowerbutton

script in error `providers/scripts/PowerAction.ps1`
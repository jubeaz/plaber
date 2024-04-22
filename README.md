# plaber 

derived from [GOAD](https://github.com/Orange-Cyberdefense/GOAD/tree/main)



# RUN LAB

## start all vms

```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done
```

## enable fw
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```

## enjoy

# BUILD
## vagrant
### build all  vms
```bash
vagrant up
```

### stop all  vms
```bash
vagrant halt
```


### disable all buildint NAT interfaces
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage modifyvm $b --cableconnected1 off"; vboxmanage modifyvm $b  --cableconnected1 off; done

for b in $(cat Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage modifyvm $b --cableconnected1 off"; vboxmanage modifyvm $b  --cableconnected1 off; done
```


### start all vagrant box
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done
```

## ansible

### build fw
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-fw.yml
```

* restart firewall :
    * `echo "vboxmanage controlvm $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep fw | cut -d'"' -f 2) acpipowerbutton"`
    * `vboxmanage controlvm $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep fw | cut -d'"' -f 2) acpipowerbutton`
    * `vboxmanage controlvm $(cat Vagrantfile  | grep fw | cut -d'"' -f 2) acpipowerbutton`
    * `vboxmanage startvm $(cat Vagrantfile  | grep fw | cut -d'"' -f 2) --type headless`
* correct public ip machines:
    * `evil-winrm -i 192.168.2.101 -u vagrant -p vagrant`
    * `netsh.exe int ipv4 set address 'Ethernet 2' static 172.16.1.10 mask=255.255.255.0 gateway=172.16.1.254`

### build lab
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-lab.yml
```

## enable 
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```


# TO FIX

## ansible

### sccm
#### sccm install

wrong mssql version + no reporting ?


```
ERROR: Failed to get sql service account, Server:<fenris.haas.local>, instance:<>.  $$<Configuration Manager Prereq><04-21-2024 07:33:58.583+00><thread=4668 (0x123C)>
bran.haas.local;    SQL Server service running account;    Error;    The logon account for the SQL Server service cannot be a local user account, NT SERVICE\<sql service name> or LOCAL SERVICE.  You must configure the SQL Server service to use a valid domain account, NETWORK SERVICE, or LOCAL SYSTEM.  $$<Configuration Manager Prereq><04-21-2024 07:33:58.583+00><thread=4668 (0x123C)>
```


faudrait esayer de le passer en svcaccount (domain):
* mssql:
    * jouter en mssql_sysadmins:
        * `"HAAS\BRAN$"`
        * `"HAAS\ichi"`
        * `"HAAS\administrator"`        
* server mssql:
    * ajouter dans le groupe administrators:
        * `"HAAS\BRAN$"`
        * `"HAAS\ichi"`



#### sccm ad schema update
the tool `extadsch.exe` report an error but it is successfull need to grep ` Successfully extended the Active Directory schema.` to define success

### laps (TO TEST)

### problem
```bash
TASK [windows_domain/laps/dc : Configure Password Properties] ******************************************
changed: [dc_haas]
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (3 retries left).
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (2 retries left).
FAILED - RETRYING: [dc_weyland]: Configure Password Properties (1 retries left).
An exception occurred during task execution. To see the full traceback, use -vvv. The error was:    at Microsoft.ActiveDirectory.Management.Commands.ADCmdletBase`1.ProcessRecord()
fatal: [dc_weyland]: FAILED! => {"attempts": 3, "changed": false, "msg": "Unhandled exception while executing module: The FSMO role ownership could not be verified because its directory partition has not replicated successfully with at least one replication partner"}
```
### solution
force NTDS replication (repadmin /syncall /AdeP) and add serial: 1 

## vagrant

### public / private interface (TO TEST)
a server with a public IP does not have properly set network on
`private_network` interface

```powershell
		netsh.exe int ipv4 set address "Ethernet 2" static $ip mask=$mask
```
replace by
```powershell
		netsh.exe int ipv4 set address $if_name static $ip mask=$mask
```

manual solution
```powershell
evil-winrm -i 192.168.2.101 -u vagrant -p vagrant
netsh.exe int ipv4 set address 'Ethernet 2' static 172.16.1.10 mask=255.255.255.0 gateway=172.16.1.254
```

### shutdown on acpipowerbutton

script in error `providers/scripts/PowerAction.ps1`


# TODO
* sidhistory
    * relax trust
    * add sidhistory to some accounts
* mecm 
    * mssql GMSA mode (tester en ajoutant `"HAAS\BRAN$"` dans le groupe `L_GMSA_ICHI`)
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
vagrant up --debug --timestamp
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

## `The trust relationship between this workstation and the primary domain failed.`

need to reset DNS user role `windows_domain/member_dns`

### sccm

https://www.prajwaldesai.com/install-sql-server-2022-for-sccm-configmgr/
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

https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/replication-error-8524

```
ok: [dc_weyland] => {
    "sync_summary.stdout_lines": [
        "Replication Summary Start Time: 2024-04-23 06:07:59",
        "Beginning data collection for replication summary, this may take awhile:",
        "Source DSA          largest delta    fails/total %%   error",
        " DC01                      09m:15s    0 /   4    0  ",
        " DC02                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        "Destination DSA     largest delta    fails/total %%   error",
        " DC01                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        " DC02                      09m:10s    0 /   4    0  ",
    ]
}
ok: [dc_haas] => {
    "sync_summary.stdout_lines": [
        "Replication Summary Start Time: 2024-04-23 06:07:54",
        "Beginning data collection for replication summary, this may take awhile:",
        "Source DSA          largest delta    fails/total %%   error",
        "Destination DSA     largest delta    fails/total %%   error",
    ]
}
ok: [dc_research_weyland] => {
    "sync_summary.stdout_lines": [
        "Replication Summary Start Time: 2024-04-23 06:07:54",
        "Beginning data collection for replication summary, this may take awhile:",
        "Source DSA          largest delta    fails/total %%   error",
        " DC01                      09m:10s    0 /   4    0  ",
        " DC02                      09m:50s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        "Destination DSA     largest delta    fails/total %%   error",
        " DC01                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        " DC02                      09m:10s    0 /   4    0  ",
    ]
}

TASK [windows_domain/laps/dc : debug] ******************************************************************
ok: [dc_weyland] => {
    "sync_queue.stdout_lines": [
        "Repadmin: running command /Queue against full DC localhost",
        "Queue contains 0 items.",
    ]
}
ok: [dc_haas] => {
    "sync_queue.stdout_lines": [
        "Repadmin: running command /Queue against full DC localhost",
        "Queue contains 0 items.",
    ]
}
ok: [dc_research_weyland] => {
    "sync_queue.stdout_lines": [
        "Repadmin: running command /Queue against full DC localhost",
        "Queue contains 0 items.",
    ]
}
```


# TODO

## vagrant
```
  config.vm.provider "virtualbox" do |vb|
       vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"]        
  end
```

## ansible
* sidhistory
    * relax trust
    * add sidhistory to some accounts
* mecm 
    * mssql GMSA mode (tester en ajoutant `"HAAS\BRAN$"` dans le groupe `L_GMSA_ICHI`)
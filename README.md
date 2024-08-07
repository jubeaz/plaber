# plaber 

derived from [GOAD](https://github.com/Orange-Cyberdefense/GOAD/tree/main)


notes:
* vagrant is only used for initial provisionning since default nat interface is disconnected after provisionning


# Run lab

* start all vms

```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done
```

* enable fw
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```

* enjoy

# Stop lab
* stop all vms
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage controlvm $b acpipowerbutton; done
```
# BUILD
## vagrant
* build all  vms
```bash
vagrant up --debug --timestamp
```

* stop all  vms
```bash
vagrant halt
```


* disable all vms buildint NAT interfaces
```bash
vboxmanage list vms | grep nrunner | sed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} vboxmanage modifyvm {} --cableconnected1 off

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage modifyvm $b  --cableconnected1 off; done
```

* restart all vms
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done
```

## ansible

* build fw
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-fw.yml
ansible-playbook -i ./inventories/netrunner_base/netrunner.yml ./playbooks/build-fw.yml
```

* build lab
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-lab.yml
```

* enable 
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```

# To fix on vagrant

# To fix on ansible


## `The trust relationship between this workstation and the primary domain failed.`

need to reset DNS user role `windows_domain/member_dns`

## sccm

la commande d'installation de la console ne passe pas.

retest discovery task with computed group DN

intall console sur windows 10
https://learn.microsoft.com/fr-fr/mem/configmgr/core/servers/deploy/install/install-consoles

C:\setup\cd.retail.LN\SMSSETUP\BIN\I386\consolesetup.exe /q "TargetDir=%ProgramFiles%\ConfigMgr Console" DefaultSiteServerName=bran.haas.local


https://www.prajwaldesai.com/install-sql-server-2022-for-sccm-configmgr/


### laps (TO TEST)

### problem

https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/replication-error-8524

```
ok: [dc_weyland] => {
    "sync_summary.stdout_lines": [
        "Replication Summary Start Time: 2024-04-23 06:07:59",
        "Beginning data collection for replication summary, this may take awhile:",
        "Source DSA          largest delta    fails/total %%   error",
        " wld01                      09m:15s    0 /   4    0  ",
        " rsc01                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        "Destination DSA     largest delta    fails/total %%   error",
        " wld01                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        " rsc01                      09m:10s    0 /   4    0  ",
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
ok: [dc_research_haas] => {
    "sync_summary.stdout_lines": [
        "Replication Summary Start Time: 2024-04-23 06:07:54",
        "Beginning data collection for replication summary, this may take awhile:",
        "Source DSA          largest delta    fails/total %%   error",
        " wld01                      09m:10s    0 /   4    0  ",
        " rsc01                      09m:50s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        "Destination DSA     largest delta    fails/total %%   error",
        " wld01                      09m:55s    1 /   4   25  (8524) The DSA operation is unable to proceed because of a DNS lookup failure.",
        " rsc01                      09m:10s    0 /   4    0  ",
    ]
}
```


# TODO

## ansible

* make a dmz with a public linux box and filter from public to domain only allow linux box
* reorganize inventory:
    - linux:
        - firewall:
        - otherlinux:

### linux
* work on public interface to simulate a public website
* do something with this box

### domain

* domain gpo deployment
    * https://www.tutos.eu/1015
    * https://github.com/LoicVeirman/HardenAD/blob/Master/Modules/groupPolicy.psm1
    * faire une gpo qui interdit à un groupe (`account_services`) d'ouvrir une session interactive
* sidhistory
    * relax trust
    * add sidhistory to some accounts
* mecm 
    * mssql GMSA mode (tester en ajoutant `"HAAS\BRAN$"` dans le groupe `L_GMSA_ICHI`)

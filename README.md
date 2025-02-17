# plaber 



derived from [GOAD](https://github.com/Orange-Cyberdefense/GOAD/tree/main)


https://github.com/jborean93/exchange-test-environment

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

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage controlvm $b poweroff; done
```
# BUILD THE LAB
## vagrant

### Box consideration 
links:
* [Configure Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure?tabs=reg)
* [Configure added LSA protection](https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection)
* [Virtualization-based Security not enabled; How to enable VBS in Windows 11](https://www.thewindowsclub.com/virtualization-based-security-not-enabled-windows-11)

To enable windows VBS:
* regarding virtualization:
    * ensure ` VBoxManage modifyvm <VirtualMachineName> --nested-hw-virt on`
    * ERROR: virtualbox does not implement SLAT/EPT :(
* regarding secure boot (to test):
    * `vboxmanage modifyvm $vm_name --firmware efi64`
    * `VBoxManage modifynvram $vm_name inituefivarstore`
    * `vboxmanage modifynvram $vm_name enrollmssignatures`
    * `vboxmanage modifynvram $vm_name enrollorclpk`
* regarding memory integrity:
    * Intel PRO/1000 network drivers are not compliant
    * switch to [virtio](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers)
        *   download the latest [stable of windows driver](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso).
        * launch `virtio-win-gt-x64`
        * stop the vm
        * switch network card on virtualbox
        * emove `E1G6032E.sys` or offending drivers on windows filesystem


### provision VMs
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

```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage showvminfo $b |grep 'Cable connected: off' ; done
```

* restart all vms
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done
```

```bash
vboxmanage list runningvms
```


### SNAPSHOT

* take:
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage snapshot $b take <snapshot_name> --description="<description>" --live ;done
```

* restore:
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vvboxmanage snapshot $b restore  <snapshot_name> ;done
```

* restore current (last): 
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vvboxmanage snapshot $b restorecurrent;done
```



## ansible

* Intall requirements:
```bash
pipx install --include-deps ansible
pipx inject ansible "pywinrm[kerberos]>=0.4.0"
```

```bash
source ~/.local/pipx/venvs/ansible/bin/activate
export PYTHONPATH=~/.local/pipx/venvs/ansible/lib/python3.13/site-packages/
```

#### setup

* `/etc/hosts`:
```bash
##############################
### Netrunner 
##############################
192.168.2.100   lab_fw
172.16.1.1      wld01.weyland.local dc.weyland.local weyland.local
172.16.1.10     archer.weyland.local archer

172.16.2.1      haas01.haas.local dc.haas.local haas.local
172.16.2.10     bran.haas.local bran 

172.16.3.1      rsc01.research.haas.local dc.research.haas.local research.haas.local
172.16.3.10     fenris.research.haas.local fenris 
172.16.3.20     architect.research.haas.local architect
```


### build 

* build fw
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/0-build-fw.yml
ansible-playbook -i ./inventories/netrunner_base/netrunner.yml ./playbooks/0-build-fw.yml
```

* build lab
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/1-build-lab.yml
```

### Kerberos 

This is specialy important if CIS 2.2.22 is applied


#### setup

* `/etc/krb5.conf`:
```bash
[realms]
        HAAS.LOCAL = {
                kdc = haas01.haas.local
                kadmin_server = haas01.haas.local
        }
        RESEARCH.HAAS.LOCAL = {
                kdc = rsc01.research.haas.local
                kadmin_server = rsc01.research.haas.local
        }
        WEYLAND.LOCAL = {
                kdc = wld01.weyland.local
                kadmin_server = wld01.weyland.local
        }
[domain_realm]
        haas.local = HAAS.LOCAL
        .haas.local = HAAS.LOCAL
        research.haas.local = RESEARCH.HAAS.LOCAL
        .research.haad.local = RESEARCH.HAAS.LOCAL
        weyland.local = WEYLAND.LOCAL
        .weyland.local = WEYLAND.LOCAL
```

Include kerberos book where requiered (after domain build)
```ansible
- name: Compute kerberos Auth
  import_playbook: books/compute-kerberos-auth.yml
```



# To fix on vagrant

## vagrant pbs
Unable to download the box to solve
```
vagrant init gusztavvargadr/windows-server --box-version 2102.0.2409
vagrant up
vagrant init gusztavvargadr/windows-10 --box-version 2202.0.2409
vagrant up
```


[Unable to activate vagrant_cloud-3.1.1, because rexml-3.3.2 conflicts with rexml (~> 3.2.5)](https://github.com/hashicorp/vagrant/issues/13502)
```
sudo pacman -U /var/cache/pacman/pkg/ruby-rexml-3.2.6-2-any.pkg.tar.zst
```
[Recent version of Virtualbox 7.1.0 is not supported by vagrant 2.4.1](https://github.com/hashicorp/vagrant/issues/13501)

Edit `/usr/bin/VBox`
```
    VirtualBoxVM|virtualboxvm)
        exec "$INSTALL_DIR/VirtualBoxVM" "$@"
        ;;
    VBoxManage|vboxmanage)
    ########################
        if [[ $@ == "--version" ]]; then
           echo "7.0.0r164728"
        else
           exec "$INSTALL_DIR/VBoxManage" "$@"
        fi
        ;;
    ########################
    VBoxSDL|vboxsdl)
        exec "$INSTALL_DIR/VBoxSDL" "$@"
        ;;
```

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




# plaber 

derived from [GOAD](https://github.com/Orange-Cyberdefense/GOAD/tree/main)


https://github.com/jborean93/exchange-test-environment

notes:
* vagrant is only used for initial provisionning since default nat interface is disconnected after provisionning

# Overview

* Domains computers:
    * are provisionned with 2 interfaces:
        * (builin) `NAT network` interface for which the cable should be disconnected
        * `Internal network ` interface which will be the only one remaining. All domain computer of a domain belong to the same internal network.
    * can be access and can only access the internet thtogh the firewall.
    * they can have a public interface to reflect publically exposed hosts.

* The firewall:
    * is provisionned with:
        * 2 basic interfaces:
            * `NAT network` interface
            * `bridge network` interface
        * one interface by domain network
    * Only one of the two basic interface must be chosen according to `deployment_type` Vagrant variable.
    * The ansible firewall host `fw` should reflect this choice.

# Requierements

https://www.bloggingforlogging.com/2018/10/14/windows-host-through-ssh-bastion-on-ansible/

As domain computer are privisionned on a `Internal network` they are not directly accessible. The firewall will be in charge to route the traffic of ansible controller. Therefore, `ansible_psrp` (`sudo pacman -S python-pypsrp`) module is used to connect to windows targets with ansible and 

# Buil the Lab
## Provision (Vagrant)

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

### Chose firewall deployment mode

Edit `Vagrantfile`:
```bash

  boxes = [
    { 
      # deployment_type: "nat", # "routed" will exploit bridge interface anything else else will rely on NAT
      deployment_type: "routed", # "routed" will exploit bridge interface anything else else will rely on NAT
      bname: "nrunner_fw", 
```

### Provision VMs
* build all  vms
```bash
vagrant up --debug --timestamp
```

* stop all  vms
```bash
vagrant halt
```

* disable all vms buildint NAT interfaces in domain computers
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2 | grep -v fw); do do vboxmanage modifyvm $b  --cableconnected1 off; done
# for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage modifyvm $b  --cableconnected1 off; done
```

```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2 | grep -v fw); do vboxmanage showvminfo $b |grep 'Cable connected: off' ; done
```

* restart all vms
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2 | grep -v fw); do vboxmanage startvm $b --type headless; done

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done
```

```bash
vboxmanage list runningvms
```

## Build firewall (ansible)

Edit the inventory file to reflect the firewall deployment model set in Vagrant:
* `NATed`firewall:
    * `ansible_port` will have to be set with the proper ansible_port (portfowarding) `vboxmanage showvminfo nrunner_fw --machinereadable | grep "Forwarding"`
    * `ansible_host` will always be `127.0.0.1`
    * `disable_nat` set to `false` (obvious)
    * `ufw_in_ssh_allow`: set to ansible controller IP
    * `psrp_port`: set according to the SOCKS ssh proxy established to access domain hosts (`sshpass -p vagrant ssh -C -D 1234 -p 2222 vagrant@127.0.0.1`)
* `Bridged` firewall:
    * `ansible_port` set to `22` (obvious)
    * `ansible_host` whatever`
    * `disable_nat` set to `true` (obvious)
    * `ufw_in_ssh_allow`: set to ansible controller IP
    * `psrp_port`: no need to be defined

Then build the firewall:
```bash
/usr/bin/ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/0-build-fw.yml
/usr/bin/ansible-playbook -i ./inventories/netrunner_base/netrunner.yml ./playbooks/0-build-fw.yml
```

## Build the domains (ansible)
with `Nated` firewall a proxy must be set in orde to access the firewall:
```bash
sshpass -p vagrant ssh -C -D 1234 -p 2222 vagrant@127.0.0.1
``` 

build the lab (common)
```bash
/usr/bin/ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/1-build-lab.yml
```
Then build the lab (specific):
```bash
/usr/bin/ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/1-build-sccm.yml
```


# Run lab

## Start all vms

```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage startvm $b --type headless; done
```

## perfom actions (winrm, rdp) on domains computers (from ansible controller)
### for `bridged` deployment  
```bash
/usr/bin/aansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```

### for `Nated` deployment 

```bash
$ cat proxy-plaber.conf
strict_chain
quiet_mode
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5  127.0.0.1 1234
```

```bash
sshpass -p vagrant ssh -C -D 1234 -p 2222 vagrant@127.0.0.1

PROXYCHAINS_CONF_FILE=$PWD/proxy-plaber.conf proxychains -q xfreerdp3 /cert:ignore /u:administrator@haas.local /p:Jubeaz12345+- /v:haas01.haas.local /dynamic-resolution
```

* enjoy

# Stop the Lab
* stop all vms
```bash
for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage controlvm $b acpipowerbutton; done

for b in $(cat Vagrantfile  | grep nrunner_ | cut -d'"' -f 2); do vboxmanage controlvm $b poweroff; done
```



# Snapshot the Lab

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



## Misc

## `/etc/hosts`

* `/etc/hosts`:
```bash
##############################
### Netrunner 
##############################
192.168.2.100   lab_fw
172.16.1.1      wld01.weyland.local dc.weyland.local weyland.local
172.16.1.10     archer.weyland.local archer

172.16.2.1      haas01.haas.local dc.haas.local haas.local
172.16.2.10     eli.haas.local eli 
172.16.2.11     bran.haas.local bran 
172.16.2.20     hypoxia.haas.local hypoxia 

172.16.3.1      rsc01.research.haas.local dc.research.haas.local research.haas.local
172.16.3.10     fenris.research.haas.local fenris 
172.16.3.20     architect.research.haas.local architect
```



## Ansible Kerberos (useless because of local auth with ansible) 


* Intall requirements:
```bash
pipx install --include-deps ansible
pipx inject ansible "pywinrm[kerberos]>=0.4.0"
```

```bash
source ~/.local/pipx/venvs/ansible/bin/activate
export PYTHONPATH=~/.local/pipx/venvs/ansible/lib/python3.13/site-packages/
```

This is specialy important if CIS 2.2.22 is applied


## setup

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

# To fix

## Vagrant

### Memory limit
```
echo 3 | sudo tee /proc/sys/vm/drop_caches
```
https://forums.virtualbox.org/viewtopic.php?t=112438

### Unable to download the box
```
vagrant init gusztavvargadr/windows-server --box-version 2102.0.2409
vagrant up
vagrant init gusztavvargadr/windows-10 --box-version 2202.0.2409
vagrant up
```

### `rexml-3.3.2`

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

## Ansible


### `The trust relationship between this workstation and the primary domain failed.`

need to reset DNS user role `windows_domain/member_dns`

### sccm

#### Publication on forest domains

`Grant GenericAll on the System Management Container to "{{ sccm_server }}"`
in `windows_domain_sccm_install_extend_adschema/tasks/main.yml`

```powershell
        #$SCCMServer= "haas\bran"
        $parts = $SCCMServer.Split('\')
        $s = (Get-ADDomain $parts[0]).DNSRoot
        $sccmIdentity = Get-ADComputer -Identity $parts[1] -Server $s
        $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sccmIdentity.SID, "GenericAll", "Allow", $inheritanceType

        $domains = Get-ADForest | Select-Object -ExpandProperty Domains   
        foreach ($domain in $domains) {   
            $d = (Get-ADDomain -Identity $domain) 
            New-PSDrive -Name AD2 -PSProvider ActiveDirectory -Server $d.DNSRoot -root "//RootDSE/"     
            $systemMgmtDN = "CN=System Management,CN=System," + $d.DistinguishedName  
            write-host $systemMgmtDN  
            $acl = Get-ACL -Path "AD2:\$systemMgmtDN" 
            $acl.AddAccessRule($ace) 
            try{ 
                Set-ACL -Path "AD2:\$systemMgmtDN" -AclObject $acl  
            }    
            catch {
              
            }
            Remove-PSDrive -Name AD2
        }
```

#### Boundaries sur les domaines de la foret

#### Console install

la commande d'installation de la console ne passe pas.

retest discovery task with computed group DN

intall console sur windows 10
https://learn.microsoft.com/fr-fr/mem/configmgr/core/servers/deploy/install/install-consoles

C:\setup\cd.retail.LN\SMSSETUP\BIN\I386\consolesetup.exe /q "TargetDir=%ProgramFiles%\ConfigMgr Console" DefaultSiteServerName=bran.haas.local


https://www.prajwaldesai.com/install-sql-server-2022-for-sccm-configmgr/



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




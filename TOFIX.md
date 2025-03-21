
# To fix

# CFGMGR

# PXE task sequence
```powershell
          $domainName="haas.local"
          $sccmFQDN="bran.haas.local"
          $domainAccount="haas.local\\hagen"
          $domainPassword='haGen_Pa$$word'
          $ou="LDAP://CN=Computers,DC=haas,DC=local"
          $siteCode="HS1"
          $shareServer="bran"
          $adminPass="NuvqREtyaT_k9E5C"
```
```
TASK [windows_domain_cfgmgr_pxe : Create Task sequence] **************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was:    at System.Management.Automation.CommandProcessor.ProcessRecord()
fatal: [haas_srv02]: FAILED! => {"changed": false, "msg": "Unhandled exception while executing module: The following exception occurred while retrieving members: \"Cannot process argument because the value of argument \"member\" is null. Change the value of argument \"member\" to a non-null value.\""}
```

# working but reporting not working
some play produce error but once run again one can see they actually worked
For exemple:
```
TASK [windows_domain_cfgmgr_cfg_users : Create CM Administrative User] ***********************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was:    at System.Management.Automation.CommandProcessor.ProcessRecord()
failed: [haas_srv02] (item=HAAS\U_cfgmgr_ADMINS) => {"ansible_loop_var": "item", "changed": false, "item": "HAAS\\U_cfgmgr_ADMINS", "msg": "Unhandled exception while executing module: The following exception occurred while retrieving members: \"Cannot process argument because the value of argument \"member\" is null. Change the value of argument \"member\" to a non-null value.\""}
```

# Exchange

setup.exe /mode:recoverserver /iacceptexchangeserverlicense

# Vagrant

## Memory limit
```
echo 3 | sudo tee /proc/sys/vm/drop_caches
```
https://forums.virtualbox.org/viewtopic.php?t=112438

## Unable to download the box
```
vagrant init gusztavvargadr/windows-server --box-version 2102.0.2409
vagrant up
vagrant init gusztavvargadr/windows-10 --box-version 2202.0.2409
vagrant up
```

## `rexml-3.3.2`

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

# Ansible

## Defender and tamper protection
Tamper protection block disable real time protection will requiere a dedicated vagrant box ?


## Exchange

https://learn.microsoft.com/en-us/exchange/troubleshoot/exchange-server-welcome


## Configuration Manager

### Publication on forest domains

`Grant GenericAll on the System Management Container to "{{ cfgmgr_server }}"`
in `windows_domain_cfgmgr_install_extend_adschema/tasks/main.yml`

```powershell
        #$CFGMGRServer= "haas\bran"
        $parts = $CFGMGRServer.Split('\')
        $s = (Get-ADDomain $parts[0]).DNSRoot
        $CFGMGRIdentity = Get-ADComputer -Identity $parts[1] -Server $s
        $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $CFGMGRIdentity.SID, "GenericAll", "Allow", $inheritanceType

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


### Console install

la commande d'installation de la console ne passe pas.

retest discovery task with computed group DN

intall console sur windows 10
https://learn.microsoft.com/fr-fr/mem/configmgr/core/servers/deploy/install/install-consoles

C:\setup\cd.retail.LN\SMSSETUP\BIN\I386\consolesetup.exe /q "TargetDir=%ProgramFiles%\ConfigMgr Console" DefaultSiteServerName=bran.haas.local


https://www.prajwaldesai.com/install-sql-server-2022-for-CFGMGR-configmgr/




# libvirt

* provision vms with vagrant
* copy `cp /var/lib/libvirt/isos/bastion-12.0.14-openstack.qcow2 /var/lib/libvirt/images/vms/plaber_nrunner_bastion.qcow2`
* create a new vm:
    * `import existing disk image` (`x86_64`)
    * `var/lib/libvirt/images/vms/plaber_nrunner_bastion.qcow2` (`Generic Linux 2024`)
    * CPU `2` / Memory `4096`
    * name `plaber_nrunner_bastion` / `Virtual network 'haas': Isolated network`

# bastion setup

* configure wallix bastion:
    * set users (initial pass of `wabadmin` is `SecureWabAdmin`)
    * Configure Network: 
        * hostname: bastion
        * IPV4 on eth0: 172.17.2.30 / 172.17.2.254 / 24
        * DNS: 
            * domain name: haas.local
            * search: haas.local
            * DNS server: 172.17.2.2
        * bastion fqdn: bastion.haas.local
    * set haas01.haas.local in hosts (non)
    * add public key to root to ssh:
        * `echo 'ecdsa-sha2-nistp256 AAAAE2Vj...SNIP...Ri4TSmMq3q6IS6o= your_email@example.com' > authorized_keys && chmod 600 authorized_keys`
        * `ssh -i ~/.ssh/id_wallix -p 2242 root@bastion.haas.local`
        * `scp -i ~/.ssh/id_wallix -P 2242 ~/dev/plaber/playbooks/books/haas.conf    root@bastion.haas.local:/opt/wab/share/plugins/cred_chg/windows/haas.conf` 

# Ansible
* connect a first time to the web interface with wallix api account to change its password
* generate an API key and set it in bastion inventory `inventories/netrunner_base/host_vars/bastion/main.yml`
```json
plbr_api_key: {
  user: 'admin',
  key: "8QlOMR0nr53XRVKjSEU2DtjapEmAmBPCYrVLgtpZHfM"
}
```
* as usuall  to build but before building ansible set default domain policy Minimum password age to 0
* test with ssh:
    * ssh: `ssh jubeaz@bastion.haas.local`
    * rdp `xfreerdp /cert:ignore /u:jubeaz /p:Zaebuj12345+-   /v:bastion.haas.local /dynamic-resolution /drive:share,./ +drives`
    


# bastion access

* `xfreerdp /cert:ignore /u:jubeaz /p:Zaebuj12345+-   /v:bastion.haas.local /dynamic-resolution /drive:share,./ +drives`
* `sshpass -p Zaebuj12345+- ssh jubeaz@bastion.haas.local`




# plugins debug
using by web interface of modified code will not work. Need to debug in command line

## plugin help
```bash
cd /opt/wab/share/plugins/cred_chg/windows && sudo -u wabuser -g wabuser PYTHONPATH=$PYTHONPATH python3 -O windows.py change-credential --global --help 
```

--oldpwd 'OldP4s$w0rd' --newpwd 'n3wp@SsWord' --host 10.10.42.42 --port 22 --login 'hagen'
## windows.py

### cmdline
```bash
usage: sudo -u wabuser -g wabuser python3 -O windows.py change-credential (--global | --local | --app) [--oldpwd PASSWORD [PASSWORD ...]] [--oldprivkey PRIVATE_KEY [PRIVATE_KEY ...]] [--oldpubkey PUBLIC_KEY [PUBLIC_KEY ...]] [--newpwd PASSWORD] [--keytype TYPE] [--newprivkey PRIVATE_KEY] [--newpubkey PUBLIC_KEY] [--admin LOGIN [--adminpwd PASSWORD | --adminkey PRIVATE_KEY] --login LOGIN [--domain DOMAIN] [--] [Plugin parameters ...] [-- [Unchecked parameters ...]]

Call credential change function.

options:
  -h, --help            show this help message and exit

Domain type:
  --global              Global domain
  --local               Device local domain
  --app                 Application local domain

Account:
  --login LOGIN         User login
  --domain DOMAIN       User domain name

Old credentials (required if not reconciliation):
  --oldpwd PASSWORD [PASSWORD ...]
                        Old password
  --oldprivkey PRIVATE_KEY [PRIVATE_KEY ...]
                        Old SSH private key
  --oldpubkey PUBLIC_KEY [PUBLIC_KEY ...]
                        Old SSH public key

New credentials (required):
  --newpwd PASSWORD     New password
  --newprivkey PRIVATE_KEY
                        New SSH private key
  --newpubkey PUBLIC_KEY
                        New SSH public key
  --keytype KEY_TYPE    SSH key type

Admin account for reconciliation:
  --admin LOGIN         Admin account login
  --adminpwd PASSWORD   Admin account password (required if --admin is specified without SSH key)
  --adminkey PRIVATE_KEY
                        Admin account private key (required if --admin is specified without password)

Plugin parameters:
  --change_method CHANGE_METHOD
                        Password change protocol to use
  --port PORT           WinRM port. Only used if WinRM is set as method.Default is 5986
  --AllowUnencrypted ALLOWUNENCRYPTED
                        Fallback to HTTP if HTTPS endpoint is unavailable. Only used if WinRM is set as method.
  --admin_domain ADMIN_DOMAIN
                        The windows domain of the administrator. Used only if Samba is set as method.
  --realm REALM         Kerberos realm name. Used only if Kerberos is set as method.
  --krb_file KRB_FILE   append this Kerberos configuration file. If no value entered, /etc/krb5.conf will be used.
                        Used only if Kerberos is set as method.
                        /opt/wab/share/plugins/cred_chg/windows/krb5_realm.conf can be used as template
  --domain_controller_address DOMAIN_CONTROLLER_ADDRESS
                        Domain controller hostname or IP addressOnly used if WinRM or Samba is set as method.

```

```bash
scp -i ~/.ssh/id_wallix -P 2242 ~/dev/plaber/playbooks/books/haas.conf    root@bastion.haas.local:/opt/wab/share/plugins/cred_chg/windows/haas.conf
```

force change:
```bash
cd /opt/wab/share/plugins/cred_chg/windows && sudo -u wabuser -g wabuser PYTHONPATH=$PYTHONPATH python3 -O windows.py change-credential --global --login 'hagen' --domain 'haas.local'  --newpwd 'titi' --admin 'jubeaz'  --adminpwd 'jubeaz' --change_method 'kerberos'  --real 'HAAS.LOCAL' --krb_file '/opt/wab/share/plugins/cred_chg/windows/haas.conf'
```


env KRB5_TRACE=/dev/stderr  KRB5_CONFIG=/opt/wab/share/plugins/cred_chg/windows/haas.conf kpasswd-heimdal --admin-principal=jubeaz@HAAS.LOCAL hagen@HAAS.LOCAL


root@bastion:/opt/wab/share/plugins/cred_chg/windows# env KRB5_TRACE=/dev/stderr  KRB5_CONFIG=opt/wab/share/plugins/cred_chg/windows/haas.conf kinit jubeaz@haas.local@HAAS.LOCAL
kinit: Malformed representation of principal when parsing name jubeaz@haas.local@HAAS.LOCAL


env KRB5_TRACE=/dev/stderr \
    KRB5_CONFIG=/opt/wab/share/plugins/cred_chg/windows/haas.conf \
    kpasswd-heimdal --admin-principal=jubeaz@HAAS.LOCAL hagen@HAAS.LOCAL

# Wifi

* Configure PSK version
* Enterprise V2 on a new linux vm in order to provide access to the network  

## Enterprise V2

chose between
```
               [ Windows NPS Server ]
                         ↑
                      RADIUS
                         ↑
[ Wi-Fi Clients ] ← WLAN → [ Linux host: hostapd + DHCP ]
                         ↓
                    LAN or bridge to network
```
and
```
      [ Windows AD + NPS + DHCP Server ]
                ↑        ↑
            RADIUS   DHCP Requests
                ↑        ↑
        [ Linux host running hostapd ]
                ↑
        [ Wi-Fi Clients (802.1X) ]
```

## configure other elements
https://docs.khroners.fr/books/windows-server/page/configuration-radius-nps-pour-lauthentification-8021x-via-eap-tls

configure hostapd-mana:
* WPS
* PMF 802.11w 
* ...

```bash
rm -f res.log && wpa_supplicant -d -K  -i wlan0  -c files/fw/wpa_supplicant_haas.conf -f res.log
```

# WAC 

## Download
`https://go.microsoft.com/fwlink/?linkid=2220149&clcid=0x40c&culture=fr-fr&country=fr`

## setup 
```
Select installation mode
      Custom setup

Login Authentication/Authorization Selection
      Windows Authentication (NTLM or Kerberos)

Network access
      Remote access. Use machine name or FQDN to access Windows Admin Center on other devices.

Port Numbers
      External Port:      443
      Internal Port Range Start (Inclusive):      6601
      Internal Port Range End (Exclusive):      6610

Select TLS certificate
      Use the pre-installed TLS certificate
            5c6fa5a9c1a52a3c0a14fb2ee35fa65c6e14e406

Fully qualified domain name
      eli.haas.local

Trusted Hosts 
      Allow access to any computer

WinRM over HTTPS
      WinRM over HTTPS

Automatic updates
      Notify me of available updates without downloading or installing them

Send diagnostic data to Microsoft
      Required diagnostic data

Log File
      C:\Users\ADMINI~1.HAA\AppData\Local\Temp\2\Setup Log 2025-03-12 #002.txt
```


## Expiration date
 https://github.com/clong/DetectionLab/blob/master/Vagrant/scripts/fix-windows-expiration.ps1

 
# Exchange
https://github.com/jborean93/exchange-test-environment/tree/master

https://www.it-connect.fr/installation-pas-a-pas-de-microsoft-exchange-2019-sur-windows-server-2022/

https://github.com/clong/DetectionLab/blob/master/Azure/Ansible/roles/exchange/tasks/main.yml
https://github.com/clong/DetectionLab/blob/master/Vagrant/scripts/install-exchange.ps1

 Get-User -RecipientTypeDetails User -Filter "UserPrincipalName -ne `$null" -ResultSize unlimited | enable-mailbox

## configuration interne

### installer certif
```
New-ExchangeCertificate -FriendlyName "Self-Signed Certificate" -SubjectName "cn=YourExchangeServerName" -DomainName yourdomain.local -PrivateKeyExportable $true

Enable-ExchangeCertificate -Thumbprint <Thumbprint> -Services SMTP,IMAP,POP,IIS

```
### Configurer les Adresses de Messagerie
Configurer les politiques d'adresses de messagerie : Configurez les politiques d'adresses de messagerie pour gérer les adresses e-mail internes.
```
Set-EmailAddressPolicy -Identity "Default Policy" -EnabledEmailAddressTemplates "SMTP:@yourdomain.local"
```

Créer un connecteur d'envoi pour la messagerie interne : Configurez un connecteur d'envoi pour gérer le flux de messagerie interne.
```
New-SendConnector -Name "Internal Send Connector" -Usage "Internal" -AddressSpaces "SMTP:yourdomain.local;1" -IsScopedConnector $false -DNSRoutingEnabled $true -SourceTransportServers "YourExchangeServerName"
```

Configurer Outlook : Configurez les clients Outlook pour se connecter au serveur Exchange en utilisant les paramètres internes.


# Trust

* relax trust
* add sidhistory to some accounts

# Public web site 
* work on public interface to simulate a public website
* do something with this box
* make a dmz with a public linux box and filter from public to domain only allow linux box
* reorganize inventory:
    - linux:
        - firewall:
        - otherlinux:



 # GPO Restore

```
---
- name: check if the GPO has already been imported
  win_shell: if (Get-GPO -Name {{ pri_adcs_enrollment_gpo_name | quote }} -ErrorAction SilentlyContinue) { $true } else { $false }
  register: pri_adcs_enrollment_gpo_exists
  changed_when: no

- block:
  - name: create backup folder on host for GPO
    win_file:
      path: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup
      state: directory

  - name: copy across backup of GPO
    win_copy:
      src: gpo_backup/
      dest: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup\

  - name: restore GPO from backup
    win_shell: Import-GPO -BackupGpoName {{ pri_adcs_enrollment_gpo_name | quote }} -TargetName {{ pri_adcs_enrollment_gpo_name | quote }} -Path C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup -CreateIfNeeded

  - name: delete backup folder on host
    win_file:
      path: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup
      state: absent
      
  when: not pri_adcs_enrollment_gpo_exists.stdout_lines[0]|bool

# The backup GPO has an ID that is unique to the domain it came from, these
# next 2 tasks get's the ID for this domain's auto enroll policy and set's
# that onto the newly imported domain
- name: get policy server ID
  win_shell: (Get-CertificateEnrollmentPolicyServer -Scope All -Context Machine).Id
  register: pri_adcs_enrollment_policy_id
  changed_when: no

- name: set the policy server ID for the GPO
  win_gpo_reg:
    gpo: '{{ pri_adcs_enrollment_gpo_name }}'
    path: HKLM\Software\Policies\Microsoft\Cryptography\PolicyServers\{{ item.path | default('') }}
    name: '{{ item.name | default(omit) }}'
    value: "{{ pri_adcs_enrollment_policy_id.stdout_lines[0] }}"
    type: String
  with_items:
  - {}
  - path: 37c9dc30f207f27f61a2f7c3aed598a6e2920b54
    name: PolicyID

- name: ensure GPO is linked and enforced
  win_gpo_link:
    name: '{{ pri_adcs_enrollment_gpo_name }}'
    state: present
    enforced: yes
    enabled: yes
```
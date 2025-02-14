# Generators
## CIS server 2022 machine
### WORKGROUP Server
* 2.2.27 a transformer pour un standalone
    * Recommanded BUILTIN\Guests;NT AUTHORITY\Local account
    * to apply BUILTIN\Guests
    * `2.2.27,"User Rights Assignment","Deny log on through Remote Desktop Services (Member)",accesschk,SeDenyRemoteInteractiveLogonRight,,,,,,,"BUILTIN\Guests",=,Medium`
* 2.2.22 a transformer pour un standalone 
    * Recommanded BUILTIN\Guests;NT AUTHORITY\Local account and member of Administrators group
    * to apply BUILTIN\Guests
    * `2.2.22,"User Rights Assignment","Deny access to this computer from the network (Member)",accesschk,SeDenyNetworkLogonRight,,,,,,BUILTIN\Guests,BUILTIN\Guests,=,Medium`

```powershell
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/critera.csv'

$Filter = { $_.WRKGRP -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.ID -ne "2.2.22" -and $_.ID -ne "2.2.27"}
$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_WRKGRP.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```

### DC Server
```powershell
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/critera.csv'

$Filter = { $_.DC -eq "Y" -and $_.DEFAULT -eq "APPLY"}
$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_DC.csv'

#$Filter = { $_.DC -eq "Y" -and $_.DEFAULT -ne "APPLY"}
#$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_DC_OUT.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```

### Member Server

```powershell
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/critera.csv'

$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -eq "APPLY"}
$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_MBR.csv'

#$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -ne "APPLY"}
#$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_MBR_OUT.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```


# To study:
* 18.6.21.2: impact on server with IP public and domain IP
* LAPS (Administrative Templates: System) will conflict with GPO ?
* DisableSampleSubmission where is it
* 18.10.56.3.3.3
* c'est winrs qui permet a evil-winrm de fonctionner: WinRM is a service that enables remote management of Windows systems using the WS-Management protocol. It is the underlying service that allows tools like WinRS and PowerShell Remoting to function.

# TO improve
* 18.9.5.2

# disable NTLM

le pb que j'ai rencontré vient peut être du fait que les machines n'acceptent en netré que du kerberos alors que cis defini uniquement sendingtraffic

## Notes
* Network security: Restrict NTLM: Incoming NTLM traffic:
    * Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0
    * restrictreceivingntlmtraffic (DWORD)
        * [2] If you select "Deny all accounts," the server will deny NTLM authentication requests from incoming traffic and display an NTLM blocked error.

* Network security: Restrict NTLM:  NTLM authentication in this domain
    * Computer\HKEY_LOCAL_MACHINE\\System\CurrentControlSet\Services\Netlogon\Parameters\
    * RestrictNTLMInDomain (DWORD)
        * [7] If you select "Deny all," the domain controller will deny all NTLM pass-through authentication requests from its servers and for its accounts and return an NTLM blocked error unless the server name is on the exception list in the "Network security: Restrict NTLM: Add server exceptions for NTLM authentication in this domain" policy setting.
* Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers
    * Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0
    * restrictsendingntlmtraffic (DWORD)
        * [2] If you select "Deny all," the client computer cannot authenticate identities to a remote server by using NTLM authentication. You can use the "Network security: Restrict NTLM: Add remote server exceptions for NTLM authentication" policy setting to define a list of remote servers to which clients are allowed to use NTLM authentication.

* Network security: Restrict NTLM: Add remote server exceptions for NTLM authentication
* Network security: Restrict NTLM: Add server exceptions in this domain 

## A tester
si on met tous les serveurs en restriction NTLM sans passer le domaine.

# GPO downgrade refresh time interval

* HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\GPO
    * PollingInterval (DWORD) in minutes
    * RandomPollingInterval (DWORD) in minutes



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
$FileCriteria = './critera/cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'

$Filter = { $_.WRKGRP -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.ID -ne "2.2.22" -and $_.ID -ne "2.2.27"}
$FileOut= './findings_WRKGRP.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```

### DC Server
```powershell
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './critera/cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'

$Filter = { $_.DC -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.Category -ne "Windows Firewall"}
$FileOut= './findings_DC.csv'

#$Filter = { $_.DC -eq "Y" -and $_.DEFAULT -ne "APPLY"}
#$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_DC_OUT.csv'

Import-module .\HardeningKittyGenerator.ps1 -Force; New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```

### Member Server

```powershell
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './critera/cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'

$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -eq "APPLY"}
$FileOut= './findings_MBR.csv'

#$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -ne "APPLY"}
#$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_MBR_OUT.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut

Invoke-HardeningKitty -Mode Audit -Report  -FileFindingList $FileOut
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -FileFindingList $FileOut
```


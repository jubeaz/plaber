


# backup
$LOG="$($env:COMPUTERNAME)_$(Get-Date -Format yyyyMMdd-hhmm)"
Invoke-HardeningKitty -Mode Config -Backup -BackupFile ".\Backup_$($LOG)_Machine.csv" -FileFindingList ".\HailMary_machine.csv"
Invoke-HardeningKitty -Mode Config -Backup -BackupFile ".\Backup_$($LOG)_Machine.csv" -FileFindingList ".\findings_machine.csv" -filter { $_.APPLY -eq "TRUE" }
Invoke-HardeningKitty -Mode Config -Backup -BackupFile ".\Backup_$($LOG)_User.csv" -FileFindingList ".\HailMary_user.csv"

# audit file less
Import-Module .\HardeningKitty.psm1; Invoke-HardeningKitty -Mode Audit -Log -Report -FileFindingList ".\findings_machine.csv" -filter { $_.APPLY -ne "FALSE" -and $_.APPLY -ne "NEVER" -and $_.APPLY -ne "NOT YET"}
Invoke-HardeningKitty -Mode Audit -Log -Report -FileFindingList ".\findings_user.csv" -filter { $_.APPLY -eq "TRUE" }

# audit file less
Invoke-HardeningKitty -Mode Audit -Log -Report -FileFindingList ".\findings_machine.csv" ReportFile ".\Audit_$($LOG)_Machine.csv"
-filter { ($_.ID -ne 5.39.2) -or ($_.ID -ne 5.39.1) }
Invoke-HardeningKitty -Mode Audit -Log -Report -FileFindingList ".\findings_user.csv" -filter { $_.ID -eq 19.5.1.1 }

# apply
Import-Module .\HardeningKitty.psm1;Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList ".\apply_machine.csv" 
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList ".\findings_user.csv" -filter { $_.APPLY -eq "TRUE" }
Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList ".\findings_user.csv" -filter { $_.APPLY -eq "TRUE" }


## Hardenings
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList "C:\Users\jubeaz\Desktop\repositories\HardeningKitty\lists\finding_list_cis_microsoft_windows_11_enterprise_23h2_user.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList "C:\Users\jubeaz\Desktop\repositories\HardeningKitty\lists\finding_list_msft_security_baseline_edge_117_machine.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\nord_finding_list_msft_security_baseline_edge_128_machine.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode HailMary -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\nord_finding_list_cis_microsoft_windows_11_enterprise_23h2_machine.csv"


## Audit
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "C:\Users\jubeaz\Desktop\repositories\HardeningKitty\lists\finding_list_cis_microsoft_windows_11_enterprise_23h2_user.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "C:\Users\jubeaz\Desktop\repositories\HardeningKitty\lists\finding_list_msft_security_baseline_edge_117_machine.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\nord_finding_list_msft_security_baseline_edge_128_machine.csv"
* #Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\nord_finding_list_cis_microsoft_windows_11_enterprise_23h2_machine.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\lot-1-7.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\lot-9.csv"
* Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -SkipRestorePoint -Log -Report -FileFindingList "c:\Tools\lot-8.csv"



Import-Module C:\Users\jubeaz\Desktop\repositories\HardeningKitty\HardeningKitty.psm1;Invoke-HardeningKitty -Mode Audit -Log -Report -FileFindingList "C:\Users\jubeaz\Desktop\repositories\HardeningKitty\lists\finding_list_cis_microsoft_windows_11_enterprise_23h2_machine.csv"
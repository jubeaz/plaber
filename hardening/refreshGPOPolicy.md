```powershell
# Import the Group Policy module
Import-Module GroupPolicy

# Create a new GPO
$gpoName = "GPO Refresh Policy"
New-GPO -Name $gpoName

# Link the GPO to the domain
$gpo = Get-GPO -Name $gpoName
$domain = (Get-ADDomain).DistinguishedName
New-GPLink -Name $gpoName -Target $domain

# Configure the GPO settings to disable NTLM
Set-GPRegistryValue -Name $gpoName -Key "HKLM\Software\Policies\Microsoft\Windows\System" -ValueName "GroupPolicyRefreshTime" -Type DWord -Value 5
Set-GPRegistryValue -Name $gpoName -Key "HKLM\Software\Policies\Microsoft\Windows\System" -ValueName "GroupPolicyRefreshTimeOffset" -Type DWord -Value 1
```
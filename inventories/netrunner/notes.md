# problem
* LAPS ne mache pas tout de suite pb sur "Configure Password Properties" dc_weyland ne repond pas




# BDD

# HAAS
- own rknight
- become sa
- impersonate mhendrik
- jump WEYLAND as anson
# WAYLAND
- anson impersonate acorrea
- acorrea can become sa on HAAS

# LAPS





function test {
     param (
          [String]
          $Password,
          [String]
          $DomainAdmin,
          [String]
          $ParentDomainName,
          [String]
          $NewDomainNetbiosName,
          [String]
          $ReplicationSourceDC,
          [String]
          $NewDomainName,
          [String]
          $DomSafePassword
      )
      $domainExist=$false
      try {
          $child_domain = Get-ADDomain -Identity $NewDomainName
          $domainExist=$true
      } catch {
          $domainExist=$false
      }
      if (-not $domainExist) {
        $AnsibleChanged = $true
        $pass = ConvertTo-SecureString $Password -AsPlainText -Force
        $Cred = New-Object System.Management.Automation.PSCredential ($DomainAdmin, $pass)
        $safePassword = ConvertTo-SecureString $DomSafePassword -AsPlainText -Force
        Install-ADDSDomain -Credential $Cred -SkipPreChecks -NewDomainName $NewDomainName -NewDomainNetbiosName $NewDomainNetbiosName -ParentDomainName $ParentDomainName -ReplicationSourceDC $ReplicationSourceDC -DatabasePath "C:\Windows\NTDS" -SYSVOLPath "C:\Windows\SYSVOL" -LogPath "C:\Windows\Logs" -SafeModeAdministratorPassword $safePassword -Force -NoRebootOnCompletion
      } else {
        $AnsibleChanged = $false
      }
}
$Password='Jubeaz12345+-'
$DomSafePassword='Jubeaz12345+-'
$DomainAdmin='Administrator@weyland.local'
$ParentDomainName='weyland.local'
$NewDomainNetbiosName='dc01.weyland.local'
$NewDomainNetbiosName='RESEARCH'
$NewDomainName='research'
test -Password $Password -DomainAdmin $DomainAdmin -ParentDomainName $ParentDomainName -NewDomainNetbiosName $NewDomainNetbiosName -ReplicationSourceDC $ReplicationSourceDC -NewDomainName $NewDomainName -DomSafePassword $DomSafePassword

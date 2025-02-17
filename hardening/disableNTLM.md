

# disable NTLM

```
MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictReceivingNTLMTraffic=4,2
MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic=4,2
MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RestrictNTLMInDomain=4,7

# Disabled (0), Enable Auditing for Domain Accounts (1), Enable Auditing for all accounts (2), Not configured...All are acceptable
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name AutidReceivingNTLMTraffic
# Disabled (0), Enable Auditing for Domain Accounts (1), Enable Auditing for all accounts (2), Not configured...All are acceptable
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name RestrictReceivingNTLMTraffic


# Disable (0), Enable for Domain accounts to domain servers (1), Enable for Domain Accounts (3), Enable for Domain Servers (5), Enable All (7)..all acceptable
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name AuditNTLMInDomain
# Must be set. Disable (0), Deny for domain acct to domain servers (1), Deny for domain accts (3), Deny for Domain Servers (5), Deny all (7)
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name RestrictNTLMInDomain

#  Allow All (0), Audit all (1), Deny All(2), Not configured, are all acceptable
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name RestrictSendingNTLMTraffic
```





# disable NTLM

```
MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictReceivingNTLMTraffic=4,2
MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic=4,2
MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RestrictNTLMInDomain=4,7

Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name RestrictNTLMInDomain
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name RestrictReceivingNTLMTraffic
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name RestrictSendingNTLMTraffic
```



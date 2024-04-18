srv01 a bien l'IP public mais pas l'interne
```bash
netsh.exe int ipv4 set address 'Ethernet 2' static 172.16.1.10 mask=255.255.255.0 gateway=172.16.1.254
```

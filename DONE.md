
# wifi 

## Enterprise V1

the AP is installed on the linux firewall to test. It is enough to pentest but will not provide foothold in the network.

### test
#### firewall AP
From firewall
```bash
sudo /usr/bin/hostapd /etc/hostapd/hostapd.conf
```

#### client

```bash
touch res.log  && sudo wpa_supplicant -d -K  -i wlan0  -c files/fw/wpa_supplicant_haas.conf -f res.log
sudo wpa_supplicant -d -K  -i wlan0  -c files/fw/wpa_supplicant_haas_tls.conf -f res.log

```

To confirm either check hostapd-mana console of
```bash
cat res.log | grep "CTRL-EVENT-EAP-FAILURE"
cat res.log | grep "CTRL-EVENT-CONNECTED"
cat res.log | grep "EAP-MSCHAPV2"
cat res.log | grep "CTRL-EVENT-EAP-FAILURE EAP authentication failed
cat res.log | grep "EAP-MSCHAPV2: Authentication succeeded 
```


network={
  ssid="haas"
  scan_ssid=1
	key_mgmt=IEEE8021X
	eap=TLS
	identity="HAAS\hubeaz"
	ca_cert="/etc/cert/ca.pem"
	client_cert="hubeaz.pem"
	private_key="hubeaz.key"
	private_key_passwd="password"
	eapol_flags=3
}


## Docs
[Serveur NPS (Network Policy Server)](https://learn.microsoft.com/fr-fr/windows-server/networking/technologies/nps/nps-top)

https://learn.microsoft.com/fr-fr/windows-server/networking/technologies/nps/nps-manage-
Install-NpsServer https://www.powershellgallery.com/packages/Install-NpsServer/2.0/Content/Install-NpsServer.ps1

Autoenroll certificate RAS/IAS

https://theogindre.wordpress.com/wp-content/uploads/2017/01/mise-en-place-complc3a8te-dun-serveur-nps-sous-windows-server.pdf

https://docs.khroners.fr/books/windows-server/page/configuration-radius-nps-pour-lauthentification-8021x-via-eap-tls

sur serveur 2019 firewall sc sidtype IAS unrestricted

https://learn.microsoft.com/en-us/powershell/module/nps/?view=windowsserver2025-ps


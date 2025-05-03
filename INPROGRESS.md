
# wifi 


## V1

the AP is installed on the linux firewall to test. It is enough to pentest but will not provide foothold in the network.

## test

```bash
rm -f res.log && wpa_supplicant -d -K  -i wlan0  -c files/fw/wpa_supplicant_haas.conf -f res.log
```

cat res.log | grep "CTRL-EVENT-EAP-FAILURE"
cat res.log | grep "CTRL-EVENT-CONNECTED"
cat res.log | grep "EAP-MSCHAPV2"
cat res.log | grep "CTRL-EVENT-EAP-FAILURE EAP authentication failed
cat res.log | grep "EAP-MSCHAPV2: Authentication succeeded 


# Exchange

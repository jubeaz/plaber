* configure wallix bastion:
    * set users 
    * ip
    * set haas01.haas.local in hosts
    * en ssh (`ssh -p 2242 wabadmin@bastion.haas.local`) avec `visudo /etc/sudoers.d/wab` replace `WABSUPER ALL=(root) ALL` par `WABSUPER,WABADMIN ALL=(root) ALL` pour ansible
* as usuall  to provision
* test with ssh:
    * ssh: `ssh jubeaz@bastion.haas.local`
    * rdp `xfreerdp /cert:ignore /u:jubeaz /p:Zaebuj12345+-   /v:bastion.haas.local /dynamic-resolution /drive:share,./ +drives`
    


bastion use:
* `xfreerdp /cert:ignore /u:jubeaz /p:Zaebuj12345+-   /v:bastion.haas.local /dynamic-resolution /drive:share,./ +drives`
* `sshpass -p Zaebuj12345+- ssh jubeaz@bastion.haas.local`

root@bastion:~# ls -al /etc/sudoers.d/wab
-r--r----- 1 root root 457 Sep 12 05:34 /etc/sudoers.d/wab

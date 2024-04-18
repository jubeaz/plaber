# plaber


# vagrant

## disable all buildint NAT interfaces
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage modifyvm $b --cableconnected1 off"; vboxmanage modifyvm $b  --cableconnected1 off; done
```


## start all vagrant box
```bash
for b in $(cat ./providers/virtualbox/<lab_name|netrunner>/Vagrantfile  | grep bname: | cut -d'"' -f 2); do echo "vboxmanage startvm $b --type headless"; vboxmanage startvm $b --type headless; done
```



# ansible

## build
```
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/build-lab.yml
```

## enable 
```bash
ansible-playbook -i ./inventories/<lab_name|netrunner>/<lab_name|netrunner>.yml ./playbooks/enable-lab.yml
```


# to fix

## vagrant

a server with a public IP does not have properly set network on
`private_network` interface

manual solution
```powershell
netsh.exe int ipv4 set address 'Ethernet 2' static 172.16.1.10 mask=255.255.255.0 gateway=172.16.1.254
```

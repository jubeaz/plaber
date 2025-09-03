# Ref
* [V0.12.2](https://vagrant-libvirt.github.io/vagrant-libvirt/version/0.12.2/configuration.html)

# public interface and ufw

https://kevin.thecorams.net/posts/2020/08/libvirt-bridging/

`/etc/ufw/before.rules`:
```
-I FORWARD -m physdev --physdev-is-bridged -j ACCEPT
```


## SPICE

* https://wiki.archlinux.org/title/QEMU#SPICE
* https://www.spice-space.org/

# static IP on isolated

https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1541


```bash
VAGRANT_LOG=debug vagrant up 2>&1 | tee vagrant_debug.log
```


https://vagrant-libvirt.github.io/vagrant-libvirt/

vagrant plugin install vagrant-libvirt
https://github.com/sciurus/vagrant-mutate
https://github.com/vagrant-libvirt/vagrant-libvirt
https://iserghini.com/posts/getting-started-with-vagrant-libvirt/



```
# Use libvirt as the default provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

# Name of the bridge interface created in the steps above
bridge_iface = "br-mgmt"

# Define CPU count, memory (MB) and public IP addresses
# You can add any few or many lines as you like, assuming there is sufficient resource to run them!
nodes = {
  "vm1" => [2, 3072, '192.168.10.201'],
  "vm2" => [1, 1024, '192.168.10.202'],
  "vm3" => [1, 2048, '192.168.10.203'],
}

Vagrant.configure("2") do |config|
  # Use Ubuntu Focal image
  config.vm.box = "generic/ubuntu2004"


  # Apply config to each VM
  nodes.each do | (name, cfg) |
    numvcpus, memory, ipaddr = cfg
    
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network :public_network,
        :dev => bridge_iface,
        :mode => bridge",
        :type => "bridge",
        :ip => ipaddr

      node.vm.synced_folder('.', '/Vagrantfiles', type: 'rsync')

      node.vm.provider :libvirt do |v|
        v.memory = memory
        v.cpus = numvcpus
      end
    end
  end
end
```
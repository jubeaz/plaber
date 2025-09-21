# Ref
* [V0.12.2](https://vagrant-libvirt.github.io/vagrant-libvirt/version/0.12.2/configuration.html)


# install plugins
```
vagrant plugin install vagrant-libvirt
```

# run
```bash
VAGRANT_LOG=debug vagrant up 2>&1 | tee vagrant_debug.log

vagrant destroy --force && rm -rf .vagrant && rm /var/lib/libvirt/images/efi/*

```

# secure boot


* https://bbs.archlinux.org/viewtopic.php?id=275691
I retrieved them from https://packages.debian.org/sid/all/ovmf/download by
```bash
ar xv ovmf_2022.02-3_all.deb
tar -xvf data.tar.xz
sudo cp usr/share/OVMF/*4M* /usr/share/edk2-ovmf/x64# Install dir can be custom
```
Now secure boot is enabled in Windows and even emulated tpm works now. Anyway, I still don't understand why ArchLinux states it is disabled with the same settings. But I see it is disabled in bios so I can enable it from there, strange.


* CODE and VAR must be in a libvirt volume  and var file must be distinct for each guest.

## Vagrantfile
```ruby
require 'fileutils'

Vagrant.configure("2") do |config|
  ...
  efi_path='/var/lib/libvirt/images/efi'
  ...
  FileUtils.cp("../../ovmf/usr/share/OVMF/OVMF_CODE_4M.ms.fd", "#{efi_path}/OVMF_CODE_4M.ms.fd")
  box_defs.each do |box_def|
    FileUtils.cp("../../ovmf/usr/share/OVMF/OVMF_VARS_4M.ms.fd", "#{efi_path}/#{box_def[:bname]}_OVMF_VARS.4M.ms.fd")
    config.vm.define box_def[:bname] do |box|
      box.vm.provider "libvirt" do |box_provider|
        ...
        if box_def[:firmware] == "uefi"
          box_provider.nvram = "#{efi_path}/#{box_def[:bname]}_OVMF_VARS.4M.ms.fd"
          box_provider.loader = "#{efi_path}/OVMF_CODE_4M.ms.fd"
          ...
```


## Problem: 
```bash
-rw-r--r-- 1 libvirt-qemu libvirt-qemu  540672 Sep  5 01:40 nrunner_wld_dc_OVMF_VARS.4M.ms.fd
```

owner must be changed in order to be able to delete


## links
* https://www.labbott.name/blog/2016/09/15/secure-ish-boot-with-qemu/
*  https://docs.fedoraproject.org/en-US/quick-docs/uefi-with-qemu/
* https://wiki.archlinux.org/title/Libvirt#UEFI_support
* https://www.linux-kvm.org/downloads/lersek/ovmf-whitepaper-c770f8c.txt
* https://github.com/quickemu-project/quickemu/issues/102#issuecomment-945024268

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





https://vagrant-libvirt.github.io/vagrant-libvirt/

vagrant plugin install vagrant-libvirt
https://github.com/sciurus/vagrant-mutate
https://github.com/vagrant-libvirt/vagrant-libvirt
https://iserghini.com/posts/getting-started-with-vagrant-libvirt/



```
<domain type='kvm'>
  <name>plaber_nrunner_wld_dc</name>
  <uuid>d5d1eb0b-6627-4fab-abeb-1df403b8eabd</uuid>
  <description>Source: /home/jubeaz/tmp/providers/libvirt/netrunner_cfgmgr/Vagrantfile</description>
  <memory unit='KiB'>2097152</memory>
  <currentMemory unit='KiB'>2097152</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='pc-q35-10.0'>hvm</type>
    <loader readonly='yes' type='pflash' format='raw'>../../ovmf/usr/share/OVMF/OVMF_CODE_4M.secboot.fd</loader>
    <nvram format='raw'>../../ovmf/usr/share/OVMF/OVMF_VARS_4M.ms.fd</nvram>
    <boot dev='hd'/>
    <bootmenu enable='no'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <cpu mode='host-model' check='partial'/>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/vms/plaber_nrunner_wld_dc.img'/>
      <target dev='vda' bus='virtio'/>
      <alias name='ua-box-volume-0'/>
      <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
    </disk>
    <controller type='usb' index='0' model='qemu-xhci'>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
    </controller>
    <controller type='sata' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='pci' index='1' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='1' port='0x10'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
    </controller>
    <controller type='pci' index='2' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='2' port='0x11'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
    </controller>
    <controller type='pci' index='3' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='3' port='0x12'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
    </controller>
    <controller type='pci' index='4' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='4' port='0x13'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
    </controller>
    <controller type='pci' index='5' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='5' port='0x14'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
    </controller>
    <controller type='pci' index='6' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='6' port='0x15'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
    </controller>
    <interface type='network'>
      <mac address='52:54:00:ae:b5:7f'/>
      <source network='plaber_mgnt'/>
      <model type='virtio'/>
      <driver iommu='off'/>
      <alias name='ua-net-0'/>
      <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
    </interface>
    <interface type='network'>
      <mac address='52:54:00:67:c0:42'/>
      <source network='weyland'/>
      <model type='virtio'/>
      <driver iommu='off'/>
      <alias name='ua-net-1'/>
      <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <input type='tablet' bus='usb'>
      <address type='usb' bus='0' port='1'/>
    </input>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <tpm model='tpm-crb'>
      <backend type='emulator' version='2.0'/>
    </tpm>
    <graphics type='spice' keymap='fr'>
      <listen type='none'/>
    </graphics>
    <audio id='1' type='spice'/>
    <video>
      <model type='virtio' vram='16384' heads='1' primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
    </video>
    <watchdog model='itco' action='reset'/>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
    </memballoon>
  </devices>
</domain>

```
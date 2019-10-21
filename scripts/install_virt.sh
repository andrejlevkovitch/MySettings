#!/bin/bash

apt-get install -y \
  dnsmasq-base bridge-utils iptables \
  qemu-kvm \
  libvirt-clients libvirt-daemon-system \
  virtinst \
  virt-manager \
  libguestfs-tools

virsh net-autostart default
virsh net-start default

# Also you need manually add user to groups
# - sudo adduser username libvirt
# - sudo adduser username libvirt-qemu

# Also you may need add fallowing strings in /etc/libvirt/qemu.conf:
# - user = "root"
# - group = "root"

# After clonning some image for change ip you need start
# - sudo virt-sysprep -d my_image_name
# Also you need reconfigure ssh server after cloning
# - sudo dpkg-reconfigure openssh-server

#!/bin/bash

apt-get install -y \
  dnsmasq-base bridge-utils iptables \
  qemu-kvm \
  libvirt-clients libvirt-daemon-system \
  virtinst \
  virt-manager

virsh net-autostart default
virsh net-start default

0. create efi partition at first
1. remove xfce4-screensaver and install xscreensaver instead
2. change settings for touchpad and keyboard
3. install kernel version 5.9 (download packages from ubuntu site)
4. add `iommu=soft` to GRUB_CMDLINE_LINUX in /etc/default/grub and start
update-grub
5. in /etc/bluethooth/main.conf change setting to `AutoEnable=false`
6. add `blacklist snd_rn_pci_acp3x` and `blacklist snd_pci_acp3x`
to /etc/modprobe.d/blacklist.conf
7. remove xserver-xorg-input-synaptic (need for enabling and disabling touchpad)
8. set `compress=gzip` in /etc/initramfs-tools/initramfs.conf and start
`update-initramfs -c -k $(uname -r)`
9. reboot
10. upgrade

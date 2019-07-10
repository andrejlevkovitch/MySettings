# MySettings


## Support

Only for Ubuntu16, Ubuntu18 and Debian9(buster)

## for Debian
  1. add shortcut for open terminal. For this open settings->keyboard and
     add 'x-terminal-emulator' with shortcut `ctrl-alt-t`
  2. uncomment string in .bashrc 'force_color_prompt=yes'
  3. add /usr/sbin and /usr/local/sbin to you PATH (in .bashrc)
  4. set caps_lock as additional ctrl. For this add string
     'XKBOPTIONS="ctrl:nocaps"' in /etc/default/keyboard and run command
      - `udevadm trigger --subsystem-match=input --action=change`
  5. add current user to sudo group
      - `su root`
      - `adduser levkovitch sudo`
  6. install bash-completion (optional)
  7. add `xfce4-panel` to autoload (optional)


### Boot problems

If you have problem with load debian on you computer, then you need push `e`
while in grub and change `quet` to `nomodeset`. After it you need install 
needed firmware. For this you need add `contrib` and `non-free`, after you
need run `sudo dmesg` for check which firmware is missing.
Usually enough only:
  - `apt-get install firmware-linux-nonfree`


Also you have to check firmware by:
  - `sudo dmesg`


### Time

For reconfigure time you need:
  - dpkg-reconfigure tzdata


## Virtualbox Notes

For virtualbox you can install extension and guest addition:
	- download extension and guest addition on `download.virtualbox.org/virtualbox/`
  - execute `sudo adduser $USER vboxusers`


On guest machine:
  - install `build-essential` and `linux-headers-...`
	- install guest addition
	- execute `sudo usermod -aG vboxsf $USER`


Your shared folders will be in media folder

### Network

If you choise two network adapters in you guest mashine, you have to manually
configure second network interface. For example, if you set second adapter as
bridge, then you must add next lines in your `/etc/network/interfaces` file:

  - `allow-hotplug enp0s8`
  - `iface enp0s8 inet dhcp`


And start command: `sudo ifup enp0s8`.

## Raspberry Pi3

1. for connect lcd ttf display:
  - `git clone https://github.com/goodtft/LCD-show.git`
  - `chmod -R 755 LCD-show`
  - `cd LCD-show/`
  - `sudo ./LCD35-show`
  - (optional) add in /boot/config.txt at end:
    - `fbcon=map:1`


2. for connect to hdmi back:
  - `sudo ./LCD-hdmi`

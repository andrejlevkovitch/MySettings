# MySettings

Only for Ubuntu16, Ubuntu18 and Debian9(buster)

for Debian
  1) add /usr/sbin and /usr/local/sbin to you PATH (in .bashrc)
  2) add current user to sudo group
      - su root
      - adduser levkovitch sudo
  3) uncomment string in .bashrc 'force_color_prompt=yes'
  4) set caps_lock as additional ctrl. For this add string
     'XKBOPTIONS="ctrl:nocaps"' in /etc/default/keyboard and run command
      - udevadm trigger --subsystem-match=input --action=change
  5) add shortcut for open terminal. For this open settings->keyboard and
     add 'x-terminal-emulator' with shortcut `ctrl-alt-t`
  6) install bash-completion (optional)
  7) add `xfce4-panel` to autoload (optional)

If you have problem with load debian on you computer, then you need push `e`
while in grub and change `quet` to `nomodeset`. After it you need install 
needed firmware. For this you need add `contrib` and `non-free`, after you
need run `sudo dmesg` for check which firmware is missing.
Usually enough only:
  - apt-get install firmware-linux-nonfree

For reconfigure time you need:
  - dpkg-reconfigure tzdata


For install virtualbox:
  - add repository `deb http://download.virtualbox.org/virtualbox/debian bionic contrib'
  - download keys:
      `wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -`
      `wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -`
	- update & install latest virtualbox
	- download extension and guest addition on `download.virtualbox.org/virtualbox/`
  - execute `sudo adduser $USER vboxusers`

On guest machine:
  - install `build-essential` and `linux-headers-...`
	- install guest addition
	- `sudo usermod -aG vboxsf $USER`

You shared folders will be in media folder

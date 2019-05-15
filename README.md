# MySettings

Only for Ubuntu16, Ubuntu18 and Debian9(buster)

for Debian
  1) add /usr/sbin and /usr/local/sbin to you PATH (in .bashrc)
  2) add current user to sudo group
      - su root
      - adduser levkovitch sudo
     here can be problem with 'adduser command not found' - then just add
     /usr/sbin in you PATH
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
Usually need install:
  - amd64-microcode
  - intel-microcode
  - firmware-amd-graphisc
  - firmware-linux-nonfree

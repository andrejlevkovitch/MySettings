# MySettings

Only for Ubuntu16, Ubuntu18 and Debian9(buster)

for Debian
  1) add current user to sudo group
      - su root
      - adduser levkovitch sudo
     here can be problem with 'adduser command not found' - then just add
     /usr/sbin in you PATH
  2) set caps_lock as additional ctrl. For this add string
     'XKBOPTIONS="ctrl:nocaps"' in /etc/default/keyboard and run command
      - udevadm trigger --subsystem-match=input --action=change
  3) add shortcut for open terminal. For this open settings->keyboard and
     add 'x-terminal-emulator' with shortcut `ctrl-alt-t`
  4) add `xfce4-panel` to autoload
  5) install bash-completion
  6) uncomment string in .bashrc 'force_color_prompt=yes'

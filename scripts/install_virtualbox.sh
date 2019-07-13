#!/bin/bash
# script for installation of virtualbox

source utils.sh

VBOX_VERSION="6.0"

if [ "$CUR_SYSTEM" = "debian" ]; then
  VBOX_REPO="deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
elif [ "$CUR_SYSTEM" = "ubuntu" ]; then
  VBOX_REPO="deb http://download.virtualbox.org/virtualbox/ubuntu $(lsb_release -cs) contrib"
else
  print_error "unsupported system"
  exit 1
fi

print_delim

print_info "add repository with virtualbox"
add-apt-repository "$VBOX_REPO"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt-get update

print_info "install virtualbox"
apt-get install -y virtualbox-$VBOX_VERSION

print_delim

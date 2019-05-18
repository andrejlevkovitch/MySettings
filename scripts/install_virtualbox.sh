#!/bin/bash
# script for installation of virtualbox

VBOX_VERSION="6.0"

CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
if [ "$CUR_SYSTEM" = "debian" ]; then
  VBOX_REPO="deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
elif [ "$CUR_SYSTEM" = "ubuntu" ]; then
  VBOX_REPO="deb http://download.virtualbox.org/virtualbox/ubuntu $(lsb_release -cs) contrib"
else
  echo "unsupported system"
  exit 1
fi

echo --------------------------------------------------------------------------

echo add repository with virtualbox
add-apt-repository "$VBOX_REPO"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt-get update

echo install virtualbox
apt-get install -y virtualbox-$VBOX_VERSION

echo --------------------------------------------------------------------------

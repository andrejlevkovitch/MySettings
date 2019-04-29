#!/bin/bash
# Install newest qt from ppa repository


# TODO you need manually add qt in path in file /etc/profile or ~/.profile
# PATH=/opt/qt_version/bin
QT_PPA="ppa:beineri/opt-qt-5.12.1-$(lsb_release -cs)"

echo --------------------------------------------------------------------------

echo Install qt from ppa
add-apt-repository $QT_PPA -y
apt-get update
apt-get install qt512-meta-dbg-full -y

if [ $? -ne 0 ]; then
  echo qt can not be installed
  exit 1
fi

echo --------------------------------------------------------------------------

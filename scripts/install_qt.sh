#!/bin/bash
# Install newest qt from ppa repository


# TODO you need manually add qt in path in file /etc/profile or ~/.bashrc
# PATH=/opt/qt_version/bin

QT_PPA="ppa:beineri/opt-qt-5.12.1-$(lsb_release -cs)"

CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

echo --------------------------------------------------------------------------

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  echo Install qt from ppa
  add-apt-repository -y $QT_PPA
  apt-get update
  apt-get install -y qt512-meta-dbg-full

  if [ $? -ne 0 ]; then
    echo qt can not be installed
    exit 1
  fi
elif [ "$CUR_SYSTEM" = "debian" ]; then
  echo Install qt
  apt-get install -y qtbase5-dev

  if [ $? -ne 0 ]; then
    echo qt can not be installed
    exit 1
  fi
else
  echo "unsupported system"
  exit 1
fi

echo --------------------------------------------------------------------------

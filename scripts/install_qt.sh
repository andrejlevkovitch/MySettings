#!/bin/bash
# Install newest qt from ppa repository


# TODO you need manually add qt in path in file /etc/profile or ~/.bashrc
# PATH=/opt/qt_version/bin

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
QT_PPA="ppa:beineri/opt-qt-5.12.1-$(lsb_release -cs)"

CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

echo --------------------------------------------------------------------------

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  echo Install qt from ppa
  add-apt-repository -y $QT_PPA
  apt-get update
  apt-get install -y qt512-meta-dbg-full

  if [ $? -ne 0 ]; then
    echo -e $RED qt can not be installed $NC
    exit 1
  fi
elif [ "$CUR_SYSTEM" = "debian" ]; then
  # this is base installation, if you need install other qt libraries, like as
  # xmlpatterns, svg and others - you need install this manually, by:
  # apt-get install libqt5svg5-dev
  echo Install qt
  apt-get install -y qtbase5-dev

  if [ $? -ne 0 ]; then
    echo -e $RED qt can not be installed $NC
    exit 1
  fi
else
  echo -e $RED "unsupported system" $NC
  exit 1
fi

echo --------------------------------------------------------------------------

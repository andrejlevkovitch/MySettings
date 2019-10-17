#!/bin/bash
# Install newest qt from ppa repository


# TODO you need manually add qt in path in file /etc/profile or ~/.bashrc
# PATH=/opt/qt_version/bin

source utils.sh

print_delim

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  QT_PPA="ppa:beineri/opt-qt-5.12.1-$(lsb_release -cs)"

  print_info "Install qt from ppa"
  add-apt-repository -y $QT_PPA
  apt-get update
  apt-get install -y qt512-meta-dbg-full

  if [ $? -ne 0 ]; then
    print_error "qt can not be installed"
    exit 1
  fi
elif [ "$CUR_SYSTEM" = "debian" ]; then
  # this is base installation, if you need install other qt libraries, like as
  # xmlpatterns, svg and others - you need install this manually, by:
  # apt-get install libqt5svg5-dev
  print_info "Install qt"
  apt-get install -y qtbase5-dev

  if [ $? -ne 0 ]; then
    print_error "qt can not be installed"
    exit 1
  fi
else
  print_error "unsupported system"
  exit 1
fi

print_delim

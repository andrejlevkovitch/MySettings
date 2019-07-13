#!/bin/bash
# WARN you need already installing boost!

source utils.sh

print_delim

cd /tmp

apt-get install -y \
  autoconf automake \
  libxml2 libxml2-dev \
  libfcgi0ldbl libfcgi-dev

dpkg -s fastcgi-ch
if [ $? -ne 0 ]; then
  print_info "Install fastcgi"
  git clone https://github.com/lmovsesjan/Fastcgi-Daemon.git
  cd Fastcgi-Daemon
  autoreconf --install
  ./configure --prefix=/usr/local
  make
  checkinstall -D -y \
    --pkgname=fastcgi-ch \
    --pkgversion=1.0.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../
    rm -rf Fastcgi-Daemon
    print_error "fastcgi can not be installed"
    exit 1
  fi

  ldconfig
  cd ..
  rm -rf Fastcgi-Daemon
fi

cd $CUR_DIR

print_delim

#!/bin/bash
# WARN you need already installing boost!

CUR_DIR=$(pwd)
cd /tmp

apt-get install -y \
  autoconf automake \
  libxml2 libxml2-dev \
  libfcgi0ldbl libfcgi-dev

echo install fastcgi
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
  echo fastcgi can not be installed
  exit 1
fi

ldconfig
cd ..
rm -rf Fastcgi-Daemon


cd $CUR_DIR

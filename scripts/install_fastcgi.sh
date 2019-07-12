#!/bin/bash
# WARN you need already installing boost!

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
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
  echo -e $RED fastcgi can not be installed $NC
  exit 1
fi

ldconfig
cd ..
rm -rf Fastcgi-Daemon


cd $CUR_DIR

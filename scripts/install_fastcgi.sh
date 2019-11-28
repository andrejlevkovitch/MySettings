#!/bin/bash
# WARN you need already installing boost!

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


apt-get install -y \
  autoconf automake \
  libxml2 libxml2-dev \
  libfcgi0ldbl libfcgi-dev \
  pkg-config \
  libtool

if [ $? -ne 0 ]; then
  print_error "can not install needed packages"
  exit 1
fi

PACKAGE=fastcgi
VERSION=1.0.0
LINK="https://github.com/lmovsesjan/Fastcgi-Daemon.git"
OUT_DIR=$TMP_DIR/Fastcgi-Daemon

check_package $PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE"
  git clone $LINK $OUT_DIR

  cd $OUT_DIR
  autoreconf --install
  ./configure --prefix=/usr/local
  make

  ch_install $PACKAGE $VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $OUT_DIR
    print_error "$PACKAGE can not be installed"
    exit 1
  fi
  ldconfig

  cd $CUR_DIR
  rm -rf $OUT_DIR
fi

print_delim

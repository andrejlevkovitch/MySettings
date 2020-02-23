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

FAILURE=false

check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE"
    git clone $LINK $OUT_DIR

    cd $OUT_DIR
    autoreconf --install
    ./configure --prefix=/usr/local
    if [ $? -ne 0 ]; then
      print_error "configuration failed"
      FAILURE=true
      break
    fi

    make
    if [ $? -ne 0 ]; then
      print_error "compilation failed"
      FAILURE=true
      break
    fi

    ch_install $PACKAGE $VERSION
    if [ $? -ne 0 ]; then
      print_error "$PACKAGE can not be installed"
      FAILURE=true
      break
    fi
    ldconfig
  done
fi

cd $CUR_DIR
rm -rf $OUT_DIR

if $FAILURE; then
  exit 1
fi

print_delim

#!/bin/bash

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


print_info "Install additional packages"
apt-get install -y \
  libcairo2-dev \
  libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev \
  xz-utils \
  libtinfo5

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi

print_delim

LF_PACKAGE=lua-format
LF_VERSION=1.2.2
LF_LINK="https://github.com/andrejlevkovitch/LuaFormatter.git"
LF_ARCHIVE=$TMP_DIR/lt_ar
LF_DIR=$TMP_DIR/LuaFormatter-master

FAILURE=false

check_package $LF_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install checkinstall"

    git clone --recurse-submodules $LF_LINK $LF_DIR
    if [ $? -ne 0 ]; then
      print_error "Can not load $LF_PACKAGE"
      FAILURE=true
      break
    fi

    cd $LF_DIR
    mkdir build
    cd build
    cmake ..
    if [ $? -ne 0 ]; then
      print_error "Configuration failed"
      FAILURE=true
      break
    fi

    cmake --build . -- -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation failed"
      FAILURE=true
      break
    fi

    ch_install $LF_PACKAGE $LF_VERSION
    if [ $? -ne 0 ]; then
      print_error "Can not install $LF_PACKAGE"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm -rf $LF_ARCHIVE
rm -rf $LF_DIR

if $FAILURE; then
  exit 1
fi

print_delim

#!/bin/bash
# install latest qemu

source utils.sh

SHA256SUM="1adf405434a463f7d0be1f6461e58e4e775944e228a1d00f5fb06c92ed27758e"
VERSION="4.1.0-rc0"
PKGNAME="qemu-ch"
FOLDER="qemu-$VERSION"
LINK="https://download.qemu.org"
ARCHIVE="qemu-$VERSION.tar.xz"


print_delim

cd /tmp

apt-get install -y \
  bridge-utils

if [ ! -x "$(command -v qemu-img)" ]; then
  print_info "Install qemu"
  wget $LINK/$ARCHIVE
  echo "$SHA256SUM $ARCHIVE" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm $ARCHIVE
    print_error "qemu can not be loaded"
    exit 1
  fi

  tar xf $ARCHIVE
  rm $ARCHIVE
  cd $FOLDER
  mkdir build
  cd build
  ../configure
  make -j4
  checkinstall -D -y \
    --pkgname=$PKGNAME \
    --pkgversion=$VERSION \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf $FOLDER
    print_error "qemu can not be installed"
    exit 1
  fi
  cd /tmp
  rm -rf $FOLDER
fi

print_delim

cd $CUR_DIR

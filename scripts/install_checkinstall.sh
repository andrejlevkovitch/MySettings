#!/bin/bash

source utils.sh

print_delim

print_info "Install additional packages"
apt-get install -y \
  gettext

if [ $? -ne 0 ]; then
  print_error "Can not install additional packages"
  exit 1
fi

PACKAGE=checkinstall
VERSION=1.6.2
LINK="https://github.com/giuliomoro/checkinstall/archive/master.zip"
ARCHIVE=$TMP_DIR/checkinstall_ar
OUT_DIR=$TMP_DIR/checkinstall-master

check_package $PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE"

  package_loader $LINK $ARCHIVE
  if [ $? -ne 0 ]; then
    print_error "Can not load $PACKAGE"
    exit 1
  fi

  unzip $ARCHIVE -d $TMP_DIR
  rm $ARCHIVE
  cd $OUT_DIR

  make -j4
  make install
  ch_install $PACKAGE $VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $OUT_DIR
    print_error "Can not install $PACKAGE"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $OUT_DIR
fi

print_delim

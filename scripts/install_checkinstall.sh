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

FAILURE=false

check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE"

    package_loader $LINK $ARCHIVE
    if [ $? -ne 0 ]; then
      print_error "Can not load $PACKAGE"
      FAILURE=true
      break
    fi

    unzip $ARCHIVE -d $TMP_DIR
    cd $OUT_DIR

    make -j4
    if [ $? -ne 0 ]; then
      print_error "compilation failed"
      FAILURE=true
      break
    fi

    # XXX because we can not get deb package before installation of checkinstall
    # we install the program at first and build deb package for it after installation
    make install
    if [ $? -ne 0 ]; then
      print_error "installation failed"
      FAILURE=true
      break
    fi

    ch_install $PACKAGE $VERSION
    if [ $? -ne 0 ]; then
      print_error "Can not install $PACKAGE"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm $ARCHIVE
rm -rf $OUT_DIR

if $FAILURE; then
  exit 1
fi

print_delim

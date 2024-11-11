#!/bin/bash

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


apt-get install -y \
  libwebkit2gtk-4.1-dev

PACKAGE=vimb
VERSION=3.7.0
LINK="https://github.com/fanglingsu/vimb/archive/${VERSION}.tar.gz"
SHA_SUM="025b785891f3dc536827eaffaccd56b7d90455a310146180ee168a3cb0501577"
ARCHIVE=$TMP_DIR/vimb_ar
OUT_DIR=$TMP_DIR/vimb_dir

FAILURE=false

check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE"

    package_loader $LINK $ARCHIVE $SHA_SUM
    if [ $? -ne 0 ]; then
      print_error "Can not load $PACKAGE"
      FAILURE=true
      break
    fi

    mkdir $OUT_DIR
    tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
    cd $OUT_DIR

    make -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation error"
      FAILURE=true
      break
    fi

    ch_install $PACKAGE $VERSION
    if [ $? -ne 0 ]; then
      print_error "$PACKAGE can not be installed"
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

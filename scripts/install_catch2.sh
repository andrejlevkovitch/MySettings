#!/bin/bash

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi

print_delim

PACKAGE=catch2
VERSION=3.4.0
SHA_SUM="122928b814b75717316c71af69bd2b43387643ba076a6ec16e7882bfb2dfacbb"

LINK="https://github.com/catchorg/Catch2/archive/refs/tags/v${VERSION}.tar.gz"
ARCHIVE=$TMP_DIR/catch2_archive
OUT_DIR=$TMP_DIR/catch2_dir

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

    mkdir build
    cd build
    cmake ..
    if [ $? -ne 0 ]; then
      print_error "configuration failed"
      FAILURE=true
      break
    fi

    make -j4
    if [ $? -ne 0 ]; then
      print_error "compilation failed"
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

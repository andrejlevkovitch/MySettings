#!/bin/bash

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


PACKAGE=boost
VERSION=1.69.0
LINK="https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz"
SHA_SUM="9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb"
ARCHIVE=$TMP_DIR/boost_archive
OUT_DIR=$TMP_DIR/boost_dir

check_package $PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE"
  package_loader $LINK $ARCHIVE $SHA_SUM
  if [ $? -ne 0 ]; then
    print_error "$PACKAGE can not be loaded"
    exit 1
  fi

  mkdir $OUT_DIR
  tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
  rm $ARCHIVE
  cd $OUT_DIR

  ./bootstrap.sh --with-python=/usr/bin/python3 --with-python-root=/usr
  ./b2
  ch_install $PACKAGE $VERSION ./b2 install
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

#!/bin/bash

source utils.sh

print_delim

apt-get install -y \
  curl

if [ $? -ne 0 ]; then
  print_error "can not install needed packages"
  exit 1
fi

print_delim

PACKAGE=cmake
VERSION=3.14.1
LINK="https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1.tar.gz"
SHA_SUM="7321be640406338fc12590609c42b0fae7ea12980855c1be363d25dcd76bb25f"
ARCHIVE=$TMP_DIR/cmake_archive
OUT_DIR=$TMP_DIR/cmake_dir

check_package $PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE"
  package_loader $LINK $ARCHIVE $SHA_SUM
  if [ $? -ne 0 ]; then
    print_error "Can not load $PACKAGE"
    exit 1
  fi

  mkdir $OUT_DIR
  tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
  rm $ARCHIVE
  cd $OUT_DIR

  ./bootstrap --system-curl
  make -j4

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

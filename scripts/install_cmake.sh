#!/bin/bash

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


apt-get install -y \
  libcurl4-openssl-dev \
  zlibc zlib1g-dev

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

    ./bootstrap --system-curl
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

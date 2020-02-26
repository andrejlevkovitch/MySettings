#!/bin/bash
# NOTE: by default installed with python3 support

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


print_info "Install needed software"
apt-get install -y \
  python3-dev

if [ $? -ne 0 ]; then
  print_error "needed software can not be installed"
  exit 1
fi


PACKAGE=boost
VERSION=1.69.0
LINK="https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz"
SHA_SUM="9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb"
ARCHIVE=$TMP_DIR/boost_archive
OUT_DIR=$TMP_DIR/boost_dir

FAILURE=false

check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do # execute only once
    print_info "Install $PACKAGE"
    package_loader $LINK $ARCHIVE $SHA_SUM
    if [ $? -ne 0 ]; then
      print_error "$PACKAGE can not be loaded"
      FAILURE=true
      break
    fi

    mkdir $OUT_DIR
    tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
    cd $OUT_DIR

    ./bootstrap.sh --with-python=/usr/bin/python3 --with-python-root=/usr
    if [ $? -ne 0 ]; then
      print_error "Configuration failed"
      FAILURE=true
      break
    fi

    ./b2
    if [ $? -ne 0 ]; then
      print_error "Compilation failed"
      FAILURE=true
      break
    fi

    ch_install $PACKAGE $VERSION ./b2 install
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
  exit 1;
fi

print_delim

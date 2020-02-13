#!/bin/bash

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


apt-get install -y \
  libwebkit2gtk-4.0-dev

PACKAGE=vimb
VERSION=3.3.0
LINK="https://github.com/fanglingsu/vimb/archive/3.3.0.tar.gz"
SHA_SUM="5c6fe39b1b2ca18a342bb6683f7fd5b139ead53903f57dd9eecd5a1074576d6c"
ARCHIVE=$TMP_DIR/vimb_ar
OUT_DIR=$TMP_DIR/vimb_dir

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

  make -j4

  ch_install $PACKAGE $VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $OUT_DIR
    print_error "$PACKAGE can not be installed"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $OUT_DIR
fi

#!/usr/bin/bash

source utils.sh

print_delim

apt-get install -y \
  libluajit-5.1-dev

if [ $? -ne 0 ]; then
  print_error "can not install needed packages"
  exit 1
fi

print_delim

BSON_PACKAGE=libbson
BSON_VERSION=1.9.5
BSON_LINK="https://github.com/mongodb/libbson/archive/1.9.5.tar.gz"
BSON_ARCHIVE=$TMP_DIR/libbson_archive
BSON_DIR=$TMP_DIR/libbson_dir

check_package $BSON_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $BSON_PACKAGE"
  package_loader $BSON_LINK $BSON_ARCHIVE
  if [ $? -ne 0 ]; then
    print_error "can not load $BSON_PACKAGE"
    exit 1
  fi

  mkdir $BSON_DIR
  tar -xzvf $BSON_ARCHIVE --directory $BSON_DIR --strip-components=1
  rm $BSON_ARCHIVE
  mkdir $BSON_DIR/build-tmp
  cd $BSON_DIR/build-tmp

  cmake -DCMAKE_INSTALL_PREFIX=/usr ..
  cmake --build . -- -j4

  ch_install $BSON_PACKAGE $BSON_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $BSON_DIR
    print_info "$BSON_PACKAGE can not be installed"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $BSON_DIR
fi

LB_PACKAGE=lua-bson
LB_VERSION=1.0.0
LB_LINK="https://github.com/isage/lua-cbson.git"
LB_DIR=$TMP_DIR/lua-cbson

check_package $LB_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $LB_PACKAGE"
  git clone $LB_LINK
  mkdir $LB_DIR/build
  cd $LB_DIR/build

  cmake -DCMAKE_INSTALL_PREFIX=/usr ..
  cmake --build . -- -j4

  ch_install $LB_PACKAGE $LB_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $LB_DIR
    print_info "$LB_PACKAGE can not be installed"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $LB_DIR
fi

print_delim

#!/usr/bin/bash

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


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

FAILURE=false

check_package $BSON_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do # execute only once
    print_info "Install $BSON_PACKAGE"
    package_loader $BSON_LINK $BSON_ARCHIVE
    if [ $? -ne 0 ]; then
      print_error "can not load $BSON_PACKAGE"
      FAILURE=true
      break
    fi

    mkdir $BSON_DIR
    tar -xzvf $BSON_ARCHIVE --directory $BSON_DIR --strip-components=1
    rm $BSON_ARCHIVE
    mkdir $BSON_DIR/build-tmp
    cd $BSON_DIR/build-tmp

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    if [ $? -ne 0 ]; then
      print_error "configuration error"
      FAILURE=true
      break
    fi

    cmake --build . -- -j4
    if [ $? -ne 0 ]; then
      print_error "compilation error"
      FAILURE=true
      break
    fi

    ch_install $BSON_PACKAGE $BSON_VERSION
    if [ $? -ne 0 ]; then
      print_error "$BSON_PACKAGE can not be installed"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm -rf $BSON_DIR

if $FAILURE; then
  echo "failure"
  echo $FAILURE
  exit 1
fi

LB_PACKAGE=lua-bson
LB_VERSION=1.0.0
LB_LINK="https://github.com/isage/lua-cbson.git"
LB_DIR=$TMP_DIR/lua-cbson

FAILURE=false

check_package $LB_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $LB_PACKAGE"
    git clone $LB_LINK $LB_DIR
    if [ $? -ne 0 ]; then
      print_error "Can not download sources"
      FAILURE=true
      break
    fi

    mkdir $LB_DIR/build
    cd $LB_DIR/build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    if [ $? -ne 0 ]; then
      print_error "configuration failed"
      FAILURE=true
      break
    fi

    cmake --build . -- -j4
    if [ $? -ne 0 ]; then
      print_error "compilation failed"
      FAILURE=true
      break
    fi

    ch_install $LB_PACKAGE $LB_VERSION
    if [ $? -ne 0 ]; then
      print_error "$LB_PACKAGE can not be installed"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm -rf $LB_DIR

if $FAILURE; then
  exit 1
fi

print_delim

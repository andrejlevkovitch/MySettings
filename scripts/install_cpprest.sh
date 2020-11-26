#!/bin/bash

source utils.sh

print_delim

check_commands cmake checkinstall git
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall git"
  exit 1
fi


print_delim

PACKAGE=cpprest
VERSION=2.10.16
LINK="https://github.com/microsoft/cpprestsdk.git"
DIR=$TMP_DIR/cpprest_dir


FAILURE=false
check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do # execute only once
    print_info "Install $PACKAGE"
    git clone "$LINK" "$DIR"
    if [ $? -ne 0 ]; then
      print_error "can not load $PACKAGE"
      FAILURE=true
      break
    fi

    cd "$DIR"
    git checkout "v$VERSION"
    git submodule update --init --recursive
    mkdir "$DIR/build" -p
    cd "$DIR/build"

    cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
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

    ch_install $PACKAGE $VERSION
    if [ $? -ne 0 ]; then
      print_error "installaion failed"
      FAILURE=true
      break
    fi
  done
fi

rm -rf "$DIR"
cd "$CUR_DIR"

if $FAILURE; then
  echo "failure"
  exit 1
fi

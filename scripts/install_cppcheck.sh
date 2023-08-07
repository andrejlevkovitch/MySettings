#!/bin/bash

source utils.sh

print_delim

check_commands checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall"
  exit 1
fi


print_delim

PACKAGE=cppcheck
VERSION=2.11
SHA_SUM="ef7d77c16e6903834cc016986a60157918a90958e981863746a7f3147bfb94c6"

LINK="https://github.com/danmar/cppcheck/archive/${VERSION}.tar.gz"
ARCHIVE=$TMP_DIR/cppcheck_archive
OUT_DIR=$TMP_DIR/cppcheck_dir

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

    mkdir -p $OUT_DIR
    tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
    cd $OUT_DIR

    ch_install $PACKAGE $VERSION make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS='"-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"' -j4 install
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

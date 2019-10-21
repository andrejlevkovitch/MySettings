#!/bin/sh
# Install SDL2

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


PACKAGE=sdl2
VERSION=2.0.9
LINK="https://www.libsdl.org/release/SDL2-2.0.9.tar.gz"
SHA_SUM="255186dc676ecd0c1dbf10ec8a2cc5d6869b5079d8a38194c2aecdff54b324b1"
ARCHIVE=$TMP/sdl2_ar
OUT_DIR=$TMP/sdl2_dir

check_package $PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE"
  package_loader $LINK $ARCHIVE $SHA_SUM
  if [ $? -ne 0 ]; then
    print_error "$PACKAGE can not be loaded"
    exit 1
  fi

  tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
  rm $ARCHIVE
  mkdir $OUT_DIR/build
  cd $OUT_DIR/build

  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake --build . -- -j4

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

print_delim

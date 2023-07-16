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
VERSION=2.26.5
SHA_SUM="ad8fea3da1be64c83c45b1d363a6b4ba8fd60f5bde3b23ec73855709ec5eabf7"

LINK="https://www.libsdl.org/release/SDL2-${VERSION}.tar.gz"
ARCHIVE=$TMP_DIR/sdl2_ar
OUT_DIR=$TMP_DIR/sdl2_dir

FAILURE=false

check_package $PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE"
    package_loader $LINK $ARCHIVE $SHA_SUM
    if [ $? -ne 0 ]; then
      print_error "$PACKAGE can not be loaded"
      FAILURE=true
      break
    fi

    mkdir $OUT_DIR
    tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
    mkdir $OUT_DIR/build
    cd $OUT_DIR/build

    cmake -DCMAKE_BUILD_TYPE=Release ..
    if [ $? -ne 0 ]; then
      print_error "Configuration error"
      FAILURE=true
      break
    fi

    cmake --build . -- -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation error"
      FAILURE=true
      break
    fi

    ch_install $PACKAGE $VERSION
    if [ $? -ne 0 ]; then
      print_error "$PACKAGE can not be installed"
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

#!/bin/bash

# the script install mongo-c-driver and mongo-cxx-driver

source utils.sh

print_delim

check_commands checkinstall cmake
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall and cmake"
  exit 1
fi


PACKAGE_C=mongo-c-driver-ch
VERSION_C=1.16.1
LINK_C="https://github.com/mongodb/mongo-c-driver/archive/1.16.1.tar.gz"
SHA_SUM_C="f27fe26b4c26ccc5b77bb6f02e7d420c86df4411f64a4cd7ca3c784890649a5a"
ARCHIVE_C=$TMP_DIR/mongo_archive
OUT_DIR_C=$TMP_DIR/mongo_build

check_package $PACKAGE_C
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE_C"
  package_loader $LINK_C $ARCHIVE_C $SHA_SUM_C
  if [ $? -ne 0 ]; then
    print_error "Can not load $PACKAGE_C"
    exit 1
  fi

  mkdir $OUT_DIR_C
  tar -xzvf $ARCHIVE_C --directory $OUT_DIR_C --strip-components=1
  rm $ARCHIVE_C
  cd $OUT_DIR_C

  mkdir build_tmp
  cd build_tmp
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ..
  cmake --build . -- -j4

  ch_install $PACKAGE_C $VERSION_C
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $OUT_DIR_C
    print_error "Can not install $PACKAGE_C"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $OUT_DIR_C
fi

PACKAGE_CXX=mongo-cxx-driver-ch
VERSION_CXX=3.4.0
LINK_CXX="https://github.com/mongodb/mongo-cxx-driver/archive/r3.4.0.tar.gz"
SHA_SUM_CXX="e9772ac5cf1c996c2f77fd78e25aaf74a2abf5f3864cb31b18d64955fd41c14d"
ARCHIVE_CXX=$TMP_DIR/mongo_archive
OUT_DIR_CXX=$TMP_DIR/mongo_build

check_package $PACKAGE_CXX
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE_CXX"
  package_loader $LINK_CXX $ARCHIVE_CXX $SHA_SUM_CXX
  if [ $? -ne 0 ]; then
    print_error "Can not load $PACKAGE_CXX"
    exit 1
  fi

  mkdir $OUT_DIR_CXX
  tar -xzvf $ARCHIVE_CXX --directory $OUT_DIR_CXX --strip-components=1
  rm $ARCHIVE_CXX
  cd $OUT_DIR_CXX

  mkdir build_tmp
  cd build_tmp
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_INSTALL_PREFIX=/usr/local
    ..
  cmake --build . -- -j4

  ch_install $PACKAGE_CXX $VERSION_CXX
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $OUT_DIR_CXX
    print_error "Can not install $PACKAGE_CXX"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $OUT_DIR_CXX
fi

print_delim

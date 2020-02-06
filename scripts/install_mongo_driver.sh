#!/bin/bash

# the script install mongo-c-driver and mongo-cxx-driver

source utils.sh

print_delim

check_commands checkinstall cmake
if [ $? -ne 0 ]; then
  print_error "first you need install checkinstall and cmake"
  exit 1
fi


apt-get install -y \
  libssl-dev \
  libsasl2-dev

if [ $? -ne 0 ]; then
  print_error "can not be installed neded software"
  exit 1
fi


# XXX mongo-c-driver need `.git` directory for building, so we need download git
# repository instead archive
PACKAGE_C=mongo-c-driver-ch
VERSION_C=1.16.1
LINK_C="https://github.com/mongodb/mongo-c-driver.git"
OUT_DIR_C=$TMP_DIR/mongo_build

check_package $PACKAGE_C
if [ $? -ne 0 ]; then
  print_info "Install $PACKAGE_C"
  git clone $LINK_C $OUT_DIR_C
  if [ $? -ne 0 ]; then
    print_error "Can not load $PACKAGE_C"
    exit 1
  fi

  cd $OUT_DIR_C
  git checkout r1.16

  mkdir build_tmp
  cd build_tmp
  cmake \
    -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
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
    -DBSONCXX_POLY_USE_BOOST=1 \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
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

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
VERSION_C=1.17.0
LINK_C="https://github.com/mongodb/mongo-c-driver.git"
OUT_DIR_C=$TMP_DIR/mongo_dir

FAILURE=false

check_package $PACKAGE_C
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE_C"
    git clone "$LINK_C" "$OUT_DIR_C"
    if [ $? -ne 0 ]; then
      print_error "Can not load $PACKAGE_C"
      FAILURE=true
      break
    fi

    cd "$OUT_DIR_C"
    git checkout "$VERSION_C"

    mkdir build_tmp
    cd build_tmp
    cmake \
      -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ..
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

    ch_install "$PACKAGE_C" "$VERSION_C"
    if [ $? -ne 0 ]; then
      print_error "Can not install $PACKAGE_C"
      FAILURE=true
      break
    fi
  done
fi

cd "$CUR_DIR"
rm -rf "$OUT_DIR_C"

if $FAILURE; then
  exit 1
fi

PACKAGE_CXX=mongo-cxx-driver-ch
VERSION_CXX=3.6.1
LINK_CXX="https://github.com/mongodb/mongo-cxx-driver"
OUT_DIR_CXX=$TMP_DIR/mongo_dir

FAILURE=false

check_package "$PACKAGE_CXX"
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $PACKAGE_CXX"
    git clone "$LINK_CXX" "$OUT_DIR_CXX"
    if [ $? -ne 0 ]; then
      print_error "Can not load $PACKAGE_CXX"
      FAILURE=true
      break
    fi

    cd "$OUT_DIR_CXX"
    git checkout "r$VERSION_CXX"

    mkdir build_tmp
    cd build_tmp
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBSONCXX_POLY_USE_BOOST=ON \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ..
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

    ch_install $PACKAGE_CXX $VERSION_CXX
    if [ $? -ne 0 ]; then
      print_error "Can not install $PACKAGE_CXX"
      FAILURE=true
      break
    fi
  done
fi

cd "$CUR_DIR"
rm -rf "$OUT_DIR_CXX"

if $FAILURE; then
  exit 1
fi

print_delim

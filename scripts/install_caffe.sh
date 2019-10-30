#!/bin/bash
# This script install caffe for using OpenPose network and cuda support
# NOTE: you need install gflags, glog, protobuf. See `install_google.sh`
# NOTE: google packages have to be compiled to shared libraries

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


PACKAGE=caffe
VERSION=1.0.0
DOWNLOAD_LINK="https://github.com/andrejlevkovitch/caffe.git"
OUT_DIR=$TMP_DIR/caffe

print_info "install soft for $PACKAGE"
apt-get install -y \
  libopenblas-dev \
  libhdf5-dev \
  liblmdb-dev \
  libleveldb-dev \
  libsnappy-dev

if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi


print_delim

check_package $PACKAGE
if [ $? -ne 0 ]; then
  git clone $DOWNLOAD_LINK $OUT_DIR

  mkdir $OUT_DIR/build
  cd $OUT_DIR/build
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_C_COMPILER=gcc-7 \
    -DCMAKE_CXX_COMPILER=g++-7 \
    -DUSE_OPENCV=ON \
    -DUSE_CUDNN=ON \
    -DBLAS=Open \
    -DBUILD_python=OFF \
    $OUT_DIR
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

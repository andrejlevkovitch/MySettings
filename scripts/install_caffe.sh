#!/bin/bash
# This script install caffe for using OpenPose network and cuda support

source utils.sh

print_delim

print_info "install soft for Caffe"
apt-get install -y \
  libopenblas-dev

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi


cd /tmp

print_delim

dpkg -s caffe-ch
if [ $? -ne 0 ]; then
  git clone https://github.com/andrejlevkovitch/caffe.git

  cd caffe
  mkdir build
  cd build
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_C_COMPILER=gcc-7 \
    -DCMAKE_CXX_COMPILER=g++-7 \
    -DUSE_OPENCV=ON \
    -DUSE_CUDNN=ON \
    -DBLAS=Open \
    -DBUILD_python=OFF \
    ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=caffe-ch \
    --pkgversion=1.0.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes

  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf caffe
    print_error "caffe can not be installed"
    exit 1
  fi

  cd /tmp
  rm -rf caffe
fi

cd $CUR_DIR

print_delim

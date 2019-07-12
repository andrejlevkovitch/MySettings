#!/usr/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_DIR=$(pwd)

bash install_opencv.sh

echo --------------------------------------------------------------------------

echo install soft for Caffe
apt-get install -y \
  libprotobuf-dev \
  protobuf-compiler \
  libhdf5-dev \
  liblmdb-dev \
  libleveldb-dev \
  libsnappy-dev \
  libatlas-base-dev \
  libgflags-dev \
  libsqlite3-dev \
  libviennacl-dev \
  mesa-opencl-icd

if [ $? -ne 0 ]; then
  echo -e $RED neded packages can not be installed $NC
  exit 1
fi


echo install soft for OpenPose
apt-get install -y \
  libgoogle-glog-dev \
  ocl-icd-opencl-dev

if [ $? -ne 0 ]; then
  echo -e $RED neded packages can not be installed $NC
  exit 1
fi

# all dowload packages will be stored in /tmp and removed after installation
cd /tmp

echo --------------------------------------------------------------------------

# TODO OpenPose build caffe by self, so it not needed build it sepparetly
# dpkg -s caffe-ch
# if [ $? -ne 0 ]; then
#   echo install Caffe
#   wget "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
#   echo "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f  1.0.tar.gz" | sha256sum -c | grep -v OK
#   if [ $? -eq 0 ]; then
#     rm 1.0.tar.gz
#     echo Caffe can not be loaded
#     exit 1
#   fi

#   tar -xzvf 1.0.tar.gz
#   rm 1.0.tar.gz
#   cd caffe-1.0
#   mkdir build
#   cd build
#   export CPLUS_INCLUDE_PATH=/usr/include/python2.7
#   cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
#   cmake --build . -- -j4
#   checkinstall -D -y \
#     --pkgname=caffe-ch \
#     --pkgversion=1.0.0 \
#     --nodoc \
#     --backup=no \
#     --fstrans=no \
#     --install=yes
#   if [ $? -ne 0 ]; then
#     cd ../..
#     rm -rf caffe-1.0
#     echo Caffe can not be installed
#     exit 1
#   fi

#   cd ../..
#   rm -rf caffe-1.0
# fi

echo --------------------------------------------------------------------------

dpkg -s openpose-ch
if [ $? -ne 0 ]; then
  echo install OpenPose
  git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
  cd openpose
  mkdir build
  cd build
  # TODO here I set openCL mode for build under amd gpu
  cmake -DGPU_MODE=OPENCL ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=openpose-ch \
    --pkgversion=1.5.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../..
    rm -rf openpose
    echo -e $RED OpenPose can not be installed $NC
    exit 1
  fi

  cd ../..
  rm -rf openpose
fi

echo --------------------------------------------------------------------------

# go back
cd $CUR_DIR

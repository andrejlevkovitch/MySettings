#!/usr/bin/bash

CUR_DIR=$(pwd)

echo --------------------------------------------------------------------------

echo install soft for OpenCV
apt-get install -y \
  libgtk2.0-dev \
  libtbb-dev \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  libtiff-dev

if [ $? -ne 0 ]; then
  echo neded packages can not be installed
  exit 1
fi


# also install packages for python (in this case for python2.7)
apt-get install -y \
  python-numpy \
  libavcodec-dev \
  ffmpeg

if [ $? -ne 0 ]; then
  echo neded packages can not be installed
  exit 1
fi


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
  libviennacl-dev

if [ $? -ne 0 ]; then
  echo neded packages can not be installed
  exit 1
fi


echo install soft for OpenPose
apt-get install -y \
  libgoogle-glog-dev \
  ocl-icd-opencl-dev

if [ $? -ne 0 ]; then
  echo neded packages can not be installed
  exit 1
fi

# all dowload packages will be stored in /tmp and removed after installation
cd /tmp

echo --------------------------------------------------------------------------

# TODO caffe not build with OpenCV-4.1.0, so we use 3.4.6 version
OPENCV_VER=3.4.6
OPENCV_SHA=""
if [ "$OPENCV_VER" = "3.4.6" ]; then
  OPENCV_SHA="ca2dbe3008471b059d9f32a176ef2195eaa8a4b357ef1afaa5bfd255d501d2ec"
elif [ "$OPENCV_VER" = "4.1.0" ]; then
  OPENCV_SHA="2c75b129da2e2c8728d168b7bf14ceca2da0ebe938557b109bae6742855ede13"
else
  echo unsupported version of OpenCV: $OPENCV_VER
  exit 1
fi
dpkg -s opencv-ch
if [ $? -ne 0 ]; then
  echo install OpenCV
  wget "https://github.com/opencv/opencv/archive/$OPENCV_VER.zip"
  echo "$OPENCV_SHA  $OPENCV_VER.zip" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm $OPENCV_VER.zip
    echo opencv can not be loaded
    exit 1
  fi

  unzip $OPENCV_VER.zip
  rm $OPENCV_VER.zip
  cd opencv-$OPENCV_VER

  mkdir build
  cd build
  cmake ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=opencv-ch \
    --pkgversion=4.1.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../..
    rm -rf opencv-$OPENCV_VER
    echo opencv can not be installed
    exit 1
  fi

  cd ../..
  rm -rf opencv-$OPENCV_VER
fi


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
    echo OpenPose can not be installed
    cd ../..
    rm -rf openpose
    exit 1
  fi

  cd ../..
  rm -rf openpose
fi

echo --------------------------------------------------------------------------

# go back
cd $CUR_DIR

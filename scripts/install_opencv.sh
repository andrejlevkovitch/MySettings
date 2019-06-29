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
  python3-numpy \
  libavcodec-dev \
  ffmpeg \
  python3-matplotlib

if [ $? -ne 0 ]; then
  echo neded packages can not be installed
  exit 1
fi


cd /tmp

echo --------------------------------------------------------------------------

# NOTE: caffe not build with OpenCV-4.1.0, so we use 3.4.6 version
OPENCV_VER=4.1.0
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
  cmake \
    -DBUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    ..
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

cd $CUR_DIR

echo Install python3 support
pip3 install opencv-python opencv-contrib-python
if [ $? -ne 0 ]; then
  echo Can not install python3 support for opencv
  exit 1
fi

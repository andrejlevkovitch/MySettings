#!/usr/bin/bash

source utils.sh

print_delim

print_info "install soft for OpenCV"
apt-get install -y \
  libgtk2.0-dev \
  libtbb-dev \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  libtiff-dev

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi


# also install packages for python (in this case for python2.7)
apt-get install -y \
  python3-numpy \
  libavcodec-dev \
  ffmpeg \
  python3-matplotlib

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi


cd /tmp

print_delim

# NOTE: caffe not build with OpenCV-4.1.0, so we use 3.4.6 version
OPENCV_VER=4.1.0
OPENCV_SHA=""
if [ "$OPENCV_VER" = "3.4.6" ]; then
  OPENCV_SHA="ca2dbe3008471b059d9f32a176ef2195eaa8a4b357ef1afaa5bfd255d501d2ec"
  CONTRIB_SHA="8987437291c328271a0929f1a7af7f5029126a2080020b30324d131e1b59c19f  3.4.6.zip"
elif [ "$OPENCV_VER" = "4.1.0" ]; then
  OPENCV_SHA="2c75b129da2e2c8728d168b7bf14ceca2da0ebe938557b109bae6742855ede13"
  CONTRIB_SHA="b4013495ac6c4dd05dcad1c90b6c731b488a1d775835175327f3c20884269715"
else
  print_error "unsupported version of OpenCV: $OPENCV_VER"
  exit 1
fi
dpkg -s opencv-ch
if [ $? -ne 0 ]; then
  print_info "install OpenCV"
  wget "https://github.com/opencv/opencv/archive/$OPENCV_VER.zip"
  echo "$OPENCV_SHA  $OPENCV_VER.zip" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm $OPENCV_VER.zip
    print_error "opencv can not be loaded"
    exit 1
  fi

  unzip $OPENCV_VER.zip
  rm $OPENCV_VER.zip
  cd opencv-$OPENCV_VER

  wget "https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip"
  echo "$CONTRIB_SHA  $OPENCV_VER.zip" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    cd ../
    rm -rf opencv-$OPENCV_VER
    print_error "opencv can not be loaded"
    exit 1
  fi

  unzip $OPENCV_VER.zip
  rm $OPENCV_VER.zip

  mkdir build
  cd build
  cmake \
    -DCMAKE_C_COMPILER=gcc-7 \
    -DCMAKE_CXX_COMPILER=g++-7 \
    -DBUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-$OPENCV_VER/modules \
    -DWITH_CUDA=ON \
    ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=opencv-ch \
    --pkgversion=$OPENCV_VER \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../..
    rm -rf opencv-$OPENCV_VER
    print_error "opencv can not be installed"
    exit 1
  fi

  cd ../..
  rm -rf opencv-$OPENCV_VER
fi

print_delim

cd $CUR_DIR

print_info "Install python3 support"
pip3 install opencv-python opencv-contrib-python
if [ $? -ne 0 ]; then
  print_error "Can not install python3 support for opencv"
  exit 1
fi

print_delim

#!/usr/bin/bash

CUR_DIR=$(pwd)

cd /tmp

apt-get install -y \
  libluajit-5.1-dev

dpkg -s libbson-ch
if [ $? -ne 0 ]; then
  wget "https://github.com/mongodb/libbson/archive/1.9.5.tar.gz"
  tar -xzvf 1.9.5.tar.gz
  rm 1.9.5.tar.gz
  cd libbson-1.9.5
  mkdir build-tmp
  cd build-tmp
  cmake -DCMAKE_INSTALL_PREFIX=/usr ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=libbson-ch \
    --pkgversion=1.9.5 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    echo libbson can not be installed
    exit 1
  fi
  cd ../../
  rm -rf libbson-1.9.5
fi

dpkg -s lua-bson-ch
if [ $? -ne 0 ]; then
  git clone https://github.com/isage/lua-cbson.git
  cd lua-cbson
  mkdir build
  cd build
  cmake -DCMAKE_INSTALL_PREFIX=/usr ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=lua-cbson-ch \
    --pkgversion=1.0.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    echo lua-cbson can not be installed
    exit 1
  fi
  cd ../..
  rm -rf lua-cbson
fi


cd $CUR_DIR

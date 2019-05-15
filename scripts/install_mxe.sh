#!/bin/bash
# Install mxe cross environment

CUR_DIR=$(pwd)

echo --------------------------------------------------------------------------

echo Preparing for MXE installation cross environment
apt-get install -y \
  autoconf \
  automake \
  autopoint \
  bash \
  bison \
  bzip2 \
  flex \
  g++ \
  g++-multilib \
  gettext \
  git \
  gperf \
  intltool \
  libc6-dev-i386 \
  libgdk-pixbuf2.0-dev \
  libltdl-dev \
  libssl-dev \
  libtool-bin \
  libxml-parser-perl \
  lzip \
  make \
  openssl \
  p7zip-full \
  patch \
  perl \
  pkg-config \
  python \
  ruby \
  sed \
  unzip \
  wget \
  xz-utils

if [ $? -ne 0 ]; then
  echo soft for MXE can not be installed
  exit 1
fi


echo MXE base installation
if [ ! -d "/opt/mxe" ]; then
  cd /opt
  git clone https://github.com/andrejlevkovitch/mxe.git
  cd mxe
else
  cd /opt/mxe
  git pull
fi

make MXE_TARGETS="x86_64-w64-mingw32.shared" MXE_PLUGIN_DIRS="plugins/gcc8" gcc cmake qt5 gdb

if [ $? -ne 0 ]; then
  echo MXE installation failed
  exit 1
fi


# TODO You should add to the PATH dir /opt/mxe/usr/bin manually
# For run under wine you need set WINEPATH
# export WINEPATH="/opt/mxe/usr/x86_64-w64-mingw32.shared/bin;/opt/mxe/usr/x86_64-w64-mingw32.shared/qt5/bin"
# you can set this in ~/.bashrc

echo Install wine
apt-get install -y \
  wine-development

if [ $? -ne 0 ]; then
  echo wine can not be installed
  exit 1
fi

cd $CUR_DIR

echo --------------------------------------------------------------------------

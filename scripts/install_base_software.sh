#!/bin/bash
# Install additional software

CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

echo --------------------------------------------------------------------------

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  echo add testing ppa
  add-apt-repository ppa:ubuntu-toolchain-r/test
elif [ "$CUR_SYSTEM" = "debian" ] && [ "$(lsb_release -cs)" != "buster" ]; then
  echo upgrade debian to buster
  sed -i "s/$(lsb_release -cs)/buster/g" /etc/apt/sources.list
  apt-get update
  apt-get upgrade -y
  apt-get dist-upgrade -y
else
  echo unsupported system: $CUR_SYSTEM
  exit 1
fi


echo ugrade system before installation
apt-get update
apt-get -y upgrade

echo install base soft
apt-get install -y \
  wget \
  software-properties-common

if [ $? -ne 0 ]; then
  echo base soft can not be installed
  exit 1
fi


echo Install video drivers
apt-get install -y \
  build-essential mesa-common-dev \
  libgl1-mesa-dev libgles2-mesa-dev \
  xvfb

if [ $? -ne 0 ]; then
  echo video drivers can not be installed
  exit 1
fi

# Especially needed for sdl2
echo Install audio drivers 
apt-get install -y \
  libasound2-dev \
  libpulse-dev

if [ $? -ne 0 ]; then
  echo audio drivers can not be installed
  exit 1
fi

echo Install usefull utils
apt-get install -y \
  apt-file \
  libpng-dev \
  zlibc zlib1g-dev \
  net-tools \
  automake \
  lm-sensors

if [ $? -ne 0 ]; then
  echo additional soft can not be installed
  exit 1
fi

# lm-sensors - utilite for controll temperature of processor

echo --------------------------------------------------------------------------

#!/bin/bash
# Install additional software

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

echo --------------------------------------------------------------------------

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  echo add testing ppa
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
elif [ "$CUR_SYSTEM" = "debian" ]; then
  if [ "$(lsb_release -cs)" != "buster" ]; then
    echo upgrade debian to buster
    sed -i "s/$(lsb_release -cs)/buster/g" /etc/apt/sources.list
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
  fi
else
  echo -e $RED unsupported system: $CUR_SYSTEM $NC
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
  echo -e $RED base soft can not be installed $NC
  exit 1
fi


echo Install video drivers
apt-get install -y \
  build-essential mesa-common-dev \
  libgl1-mesa-dev libgles2-mesa-dev \
  xvfb

if [ $? -ne 0 ]; then
  echo -e $RED video drivers can not be installed $NC
  exit 1
fi

# Especially needed for sdl2
echo Install audio drivers 
apt-get install -y \
  libasound2-dev \
  libpulse-dev

if [ $? -ne 0 ]; then
  echo -e $RED audio drivers can not be installed $NC
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
  echo -e $RED additional soft can not be installed $NC
  exit 1
fi

# lm-sensors - utilite for controll temperature of processor

echo --------------------------------------------------------------------------

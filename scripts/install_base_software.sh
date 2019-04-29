#!/bin/bash
# Install additional software

echo --------------------------------------------------------------------------

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
  libgl1-mesa-dev libgles2-mesa-dev freeglut3-dev \
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

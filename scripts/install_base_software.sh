#!/bin/bash
# Install additional software

source utils.sh

print_delim

# XXX be carefull with different debian/ubuntu distributives


print_info "upgrade system before installation"
apt-get update
apt-get -y upgrade

print_info "install base soft"
apt-get install -y \
  wget \
  software-properties-common \
  pkg-config \
  autoconf automake \
  libtool \
  zlibc zlib1g-dev \
  unzip

if [ $? -ne 0 ]; then
  print_error "base soft can not be installed"
  exit 1
fi


print_info "Install video drivers"
apt-get install -y \
  build-essential mesa-common-dev \
  libgl1-mesa-dev libgles2-mesa-dev \
  xvfb

if [ $? -ne 0 ]; then
  print_error "video drivers can not be installed"
  exit 1
fi

# Especially needed for sdl2
print_info "Install audio drivers"
apt-get install -y \
  libasound2-dev \
  libpulse-dev

if [ $? -ne 0 ]; then
  print_error "audio drivers can not be installed"
  exit 1
fi

print_info "Install usefull utils"
apt-get install -y \
  apt-file \
  net-tools \
  lm-sensors

# lm-sensors - utilite for controll temperature of processor

if [ $? -ne 0 ]; then
  print_error "additional soft can not be installed"
  exit 1
fi

print_delim

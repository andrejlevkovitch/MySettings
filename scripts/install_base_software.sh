#!/bin/bash
# Install additional software

source utils.sh

print_delim

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  print_info "add testing ppa"
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
elif [ "$CUR_SYSTEM" = "debian" ]; then
  if [ "$(lsb_release -cs)" != "buster" ]; then
    print_info "upgrade debian to buster"
    sed -i "s/$(lsb_release -cs)/buster/g" /etc/apt/sources.list
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
  fi
else
  print_error "unsupported system: $CUR_SYSTEM"
  exit 1
fi


print_info "upgrade system before installation"
apt-get update
apt-get -y upgrade

print_info "install base soft"
apt-get install -y \
  wget \
  software-properties-common \
  pkg-config \
  autoconf

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
  libpng-dev \
  zlibc zlib1g-dev \
  net-tools \
  automake \
  lm-sensors

# lm-sensors - utilite for controll temperature of processor

if [ $? -ne 0 ]; then
  print_error "additional soft can not be installed"
  exit 1
fi

print_delim

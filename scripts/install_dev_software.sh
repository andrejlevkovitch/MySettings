#!/bin/bash
# Install software neded for programming
# have to be run only after install_base_software.sh

source utils.sh

print_delim

print_info "Install software for programming"
apt-get install -y \
  git \
  doxygen graphviz \
  luajit lua-ldoc \
  python3-dev python-dev python3-pip \
  gdb gdbserver \
  cppcheck \
  tree

if [ $? -ne 0 ]; then
  print_error "soft for programming can not be installed"
  exit 1
fi

print_delim

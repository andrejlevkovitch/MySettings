#!/bin/bash
# Install software neded for programming
# have to be run only after install_base_software.sh

source utils.sh

print_delim

print_info "Install software for programming"
apt-get install -y \
  git git-lfs \
  graphviz gnuplot \
  doxygen \
  luajit lua-ldoc lua-busted \
  python3-dev python-dev python3-pip \
  gdb gdbserver \
  tidy \
  tree \
  vifm \
  shellcheck

# tidy        - checking HTML
# graphviz    - graph visualization
# gnuplot     - plot vizualization
# lua-ldoc    - tool for generating lua documentation
# lua-busted  - lua unit testing (BDD-style)
# git-lfs     - git module for versioning big files with git


if [ $? -ne 0 ]; then
  print_error "soft for programming can not be installed"
  exit 1
fi

print_delim

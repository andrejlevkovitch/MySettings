#!/bin/bash
# TODO not tests, needed qt. Better load AppImage of Tiled - this fast and simple. Just 
# load it from official site

source utils.sh

print_delim

cd /tmp

dpkg -s tiled-ch
if [ $? -ne 0 ]; then
  print_info "Install Tiled"
  wget "https://github.com/bjorn/tiled/archive/v1.2.4.tar.gz"
  echo "591d9aef53a3d618fca8f8f61101f618915584c3b188595c8632d38d97352ad8  v1.2.4.tar.gz" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm v1.2.4.tar.gz
    print_error "Tiled can not be loaded"
    exit 1
  fi

  tar -xzvf v1.2.4.tar.gz
  rm v1.2.4.tar.gz
  cd tiled-1.2.4

  qmake
  make -j4

  checkinstall -D -y \
    --pkgname=tiled-ch \
    --pkgversion=1.2.4 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../../
    rm tiled-1.2.4 -rf
    print_error "Tiled can not be installed"
    exit 1
  fi
  cd ../../
  rm -rf tiled-1.2.4
fi

cd $CUR_DIR

print_delim

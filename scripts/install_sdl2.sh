#!/bin/sh
# Install SDL2

source utils.sh

print_delim

cd /tmp

dpkg -s sdl2-ch
if [ $? -ne 0 ]; then
  print_info "Install SDL"
  wget "https://www.libsdl.org/release/SDL2-2.0.9.tar.gz"
  echo "255186dc676ecd0c1dbf10ec8a2cc5d6869b5079d8a38194c2aecdff54b324b1  SDL2-2.0.9.tar.gz" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm SDL2-2.0.9.tar.gz
    print_error "SDL2 can not be loaded"
    exit 1
  fi

  tar -xzvf SDL2-2.0.9.tar.gz
  rm SDL2-2.0.9.tar.gz
  cd SDL2-2.0.9
  mkdir build
  cd build

  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake --build . -- -j4

  checkinstall -D -y \
    --pkgname=sdl2-ch \
    --pkgversion=2.0.9 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd ../../
    rm SDL2-2.0.9 -rf
    print_error "SDL2 can not be installed"
    exit 1
  fi
  cd ../../
  rm -rf SDL2-2.0.9
fi

cd $CUR_DIR

print_delim

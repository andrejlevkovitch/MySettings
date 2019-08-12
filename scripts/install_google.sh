#!/bin/sh
# Install protobuf, gflags and glog

source utils.sh

cd /tmp

print_delim

dpkg -s protobuf-ch
if [ $? -ne 0 ]; then
  print_info "Install protobuf"
  wget https://github.com/protocolbuffers/protobuf/releases/download/v3.9.1/protobuf-all-3.9.1.tar.gz
  echo "3040a5b946d9df7aa89c0bf6981330bf92b7844fd90e71b61da0c721e421a421  protobuf-all-3.9.1.tar.gz" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm protobuf-all-3.9.1.tar.gz
    print_error "protobuf can not be loaded"
    exit 1
  fi

  tar -xzvf protobuf-all-3.9.1.tar.gz
  rm protobuf-all-3.9.1.tar.gz
  cd protobuf-3.9.1
  ./autogen.sh
  ./configure
  make -j4
  checkinstall -D -y \
    --pkgname=protobuf-ch \
    --pkgversion=3.9.1 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf protobuf-3.9.1
    print_error "protobuf can not be installed"
    exit 1
  fi
  ldconfig

  cd /tmp
  rm -rf protobuf-3.9.1
fi

print_delim

dpkg -s gflags-ch
if [ $? -ne 0 ]; then
  print_info "Install gflags"
  wget https://github.com/gflags/gflags/archive/v2.2.2.tar.gz
  echo "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf  v2.2.2.tar.gz" | sha256sum -c | grep -v OK
  if [$? -eq 0 ]; then
    rm v2.2.2.tar.gz
    print_error "gflags can not be installed"
    exit 1
  fi

  tar -xzvf v2.2.2.tar.gz
  rm v2.2.2.tar.gz
  cd gflags-2.2.2
  mkdir build
  cd build
  cmake ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=gflags-ch \
    --pkgversion=2.2.2 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf gflags-2.2.2
    print_error "gflags can not be installed"
    exit 1
  fi

  cd /tmp
  rm -rf gflags-2.2.2
fi

print_delim

dpkg -s glog-ch
if [ $? -ne 0 ]; then
  print_info "Install glog"
  wget "https://github.com/google/glog/archive/v0.4.0.tar.gz"
  echo "f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c  v0.4.0.tar.gz" | sha256sum -c | grep -v OK
  if [ $? -eq 0 ]; then
    rm v0.4.0.tar.gz
    print_error "glog can not be loaded"
    exit 1
  fi

  tar -xzvf v0.4.0.tar.gz
  rm v0.4.0.tar.gz
  cd glog-0.4.0
  mkdir build
  cd build
  cmake ..
  cmake --build . -- -j4
  checkinstall -D -y \
    --pkgname=glog-ch \
    --pkgversion=0.4.0 \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes
  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf glog-0.4.0
    print_error "glog can not be installed"
    exit 1
  fi

  cd /tmp
  rm -rf glog-0.4.0
fi

cd $CUR_DIR

print_delim

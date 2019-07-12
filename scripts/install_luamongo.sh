#!/usr/bin/bash
# NOTE: first you have to remove libbson and lua-cbson if it is installed!

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_DIR=$(pwd)

cd /tmp

apt-get install -y \
  libssl-dev \
  libsasl2-dev

echo Install latest mongo-c-driver
wget "https://github.com/mongodb/mongo-c-driver/releases/download/1.14.0/mongo-c-driver-1.14.0.tar.gz"
tar -xzvf mongo-c-driver-1.14.0.tar.gz
rm mongo-c-driver-1.14.0.tar.gz
cd mongo-c-driver-1.14.0
mkdir build-tmp
cd build-tmp
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_INSTALL_PREFIX=/usr ..
cmake --build . -- -j4
checkinstall -D -y \
  --pkgname=mongo-c-driver-ch \
  --pkgversion=1.14.0 \
  --nodoc \
  --backup=no \
  --fstrans=no \
  --install=yes
if [ $? -ne 0 ]; then
  cd ../../
  rm -rf mongo-c-driver-1.14.0
  echo -e $RED mongo-c-driver can not be installed $NC
  exit 1
fi
cd ../../
rm -rf mongo-c-driver-1.14.0

echo install lua-mongo
git clone https://github.com/neoxic/lua-mongo.git
cd lua-mongo
mkdir build
cd build
cmake -DUSE_LUA_VERSION=jit -DCMAKE_INSTALL_PREFIX=/usr ..
cmake --build . -- -j4
checkinstall -D -y \
  --pkgname=lua-mongo-ch \
  --pkgversion=1.0.0 \
  --nodoc \
  --backup=no \
  --fstrans=no \
  --install=yes
if [ $? -ne 0 ]; then
  cd ../../
  rm -rf lua-mongo
  echo -e $RED mongo-c-driver can not be installed $NC
  exit 1
fi
cd ../../
rm -rf lua-mongo

cd $CUR_DIR

#!/bin/bash
# Tools: git, cmake

set -e

VERSION=1.3.6
LINK="https://github.com/Koihik/LuaFormatter.git"
ARCHIVE=/tmp/lt.tar.gz
SRC_DIR=/tmp/LuaFormatter-src
DEB_DIR=/tmp/lua-format


mkdir -p "$DEB_DIR/DEBIAN"
cp "../package-files/lf-control" "$DEB_DIR/DEBIAN/control"


git clone --recurse-submodules "$LINK" "$SRC_DIR"

mkdir "$SRC_DIR/build"
cd "$SRC_DIR/build"
cmake -DCMAKE_BUILD_TYPE=Release ..

make -j"$(nproc)"
DESTDIR="$DEB_DIR" make install

dpkg-deb --build "$DEB_DIR"

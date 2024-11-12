#!/bin/bash
# Tools: wget, unzip, autoconf

set -e

VERSION=0.0.1
LINK="https://github.com/universal-ctags/ctags/archive/master.zip"
ARCHIVE=/tmp/ctags.zip
SRC_DIR=/tmp/ctags-master
DEB_DIR=/tmp/ctags


mkdir -p "$DEB_DIR/DEBIAN"
cp "../package-files/ctags-control" "$DEB_DIR/DEBIAN/control"


wget "$LINK" -O "$ARCHIVE"

unzip $ARCHIVE -d /tmp
cd $SRC_DIR

./autogen.sh
./configure

make -j"$(nproc)"
DESTDIR="$DEB_DIR" make install

dpkg-deb --build "$DEB_DIR"

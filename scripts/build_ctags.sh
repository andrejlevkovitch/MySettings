#!/bin/bash
# Tools: wget, unzip, autoconf

set -e

CTAGS_VERSION=0.0.1
CTAGS_LINK="https://github.com/universal-ctags/ctags/archive/master.zip"
CTAGS_ARCHIVE=/tmp/ctags.zip
CTAGS_DIR=/tmp/ctags-master
CTAGS_DEB_DIR=/tmp/ctags


mkdir -p "$CTAGS_DEB_DIR/DEBIAN"
cp "../package-files/ctags-control" "$CTAGS_DEB_DIR/DEBIAN/control"


wget "$CTAGS_LINK" -O "$CTAGS_ARCHIVE"

unzip $CTAGS_ARCHIVE -d /tmp
cd $CTAGS_DIR

./autogen.sh
./configure

make -j"$(nproc)"
DESTDIR="$CTAGS_DEB_DIR" make install

dpkg-deb --build "$CTAGS_DEB_DIR"

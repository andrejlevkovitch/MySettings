#!/bin/bash
# Tools: wget, tar, autoconf
# Dependencies: libncurses-dev, python3-dev

set -e

VERSION=9.1.0680
LINK="https://github.com/vim/vim/archive/v${VERSION}.tar.gz"
ARCHIVE=/tmp/vim.tar.gz
SRC_DIR=/tmp/vim-src
DEB_DIR=/tmp/vim


mkdir -p "$DEB_DIR/DEBIAN"
cp "../package-files/vim-control"  "$DEB_DIR/DEBIAN/control"
cp "../package-files/vim-postinst" "$DEB_DIR/DEBIAN/postinst"


wget "$LINK" -O "$ARCHIVE"

mkdir "$SRC_DIR"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

# add some custom syntax files
cp -f ../vim/syntax/* "$SRC_DIR/runtime/syntax"

cd "$SRC_DIR"

./configure --with-features=huge \
            --enable-python3interp=yes \
            --with-python3-config-dir="$(python3-config --configdir)" \
            --enable-multibyte \
            --enable-gui=no \
            --enable-cscope=no \
            --enable-largefile=no \
            --disable-netbeans \
            --prefix=/usr/local

make -j"$(nproc)"
DESTDIR="$DEB_DIR" make install

dpkg-deb --build "$DEB_DIR"

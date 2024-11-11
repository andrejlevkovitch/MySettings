#!/bin/bash
# Tools: wget, tar, autoconf
# Dependencies: libncurses5-dev, python3-dev

set -e

VIM_VERSION=9.1.0680
VIM_LINK="https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz"
VIM_ARCHIVE=/tmp/vim.tar.gz
VIM_DIR=/tmp/vim-src
VIM_DEB_DIR=/tmp/vim


mkdir -p "$VIM_DEB_DIR/DEBIAN"
cp "../package-files/vim-control"  "$VIM_DEB_DIR/DEBIAN/control"
cp "../package-files/vim-postinst" "$VIM_DEB_DIR/DEBIAN/postinst"


wget "$VIM_LINK" -O "$VIM_ARCHIVE"

mkdir "$VIM_DIR"
tar -xzvf "$VIM_ARCHIVE" --directory "$VIM_DIR" --strip-components=1

# add some custom syntax files
cp -f ../vim/syntax/* "$VIM_DIR/runtime/syntax"

cd $VIM_DIR

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
DESTDIR="$VIM_DEB_DIR" make install

dpkg-deb --build $VIM_DEB_DIR

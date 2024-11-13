#!/bin/bash
# Tools: wget, tar, autoconf, debhelper
# Dependencies: libncurses-dev, python3-dev

set -e

VERSION=9.1.0680
LINK="https://github.com/vim/vim/archive/v${VERSION}.tar.gz"
ARCHIVE=/tmp/vim.tar.gz
SRC_DIR=/tmp/vim
DEB_DIR=../packages/vim


printf "vim ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

mkdir -p "$SRC_DIR"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

# add some custom syntax files
cp -f ../vim/syntax/* "$SRC_DIR/runtime/syntax"

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

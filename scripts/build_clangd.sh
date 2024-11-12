#!/bin/bash
# Tools: wget, tar, cmake, debhelper

set -e

VERSION=19.1.3
LINK="https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-${VERSION}.tar.gz"
ARCHIVE=/tmp/llvm-project.tar.gz
SRC_DIR=../packages/clangd


printf "clangd ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$SRC_DIR"
dpkg-buildpackage -us -uc -b

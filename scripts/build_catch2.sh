#!/bin/bash
# Tools: wget, tar, cmake, debhelper

set -e

VERSION=3.4.0
LINK="https://github.com/catchorg/Catch2/archive/refs/tags/v${VERSION}.tar.gz"
ARCHIVE=/tmp/catch2.tar.gz
SRC_DIR=../packages/catch2


printf "catch2 ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$SRC_DIR"
dpkg-buildpackage -us -uc -b

#!/bin/bash
# Tools: wget, tar, cmake, debhelper

set -e

VERSION=3.4.0
LINK="https://github.com/catchorg/Catch2/archive/refs/tags/v${VERSION}.tar.gz"
ARCHIVE=/tmp/catch2.tar.gz
SRC_DIR=/tmp/catch2
DEB_DIR=../packages/catch2


printf "catch2 ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

mkdir -p "${SRC_DIR}"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

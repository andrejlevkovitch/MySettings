#!/bin/bash
# Tools: wget, tar, debhelper
# Dependencies: libcurl4-openssl-dev

set -e

VERSION=3.26.4
LINK="https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}.tar.gz"
ARCHIVE=/tmp/cmake.tar.gz
SRC_DIR=/tmp/cmake
DEB_DIR=../packages/cmake


printf "cmake ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

mkdir -p "${SRC_DIR}"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

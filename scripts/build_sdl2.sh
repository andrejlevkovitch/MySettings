#!/bin/bash
# Tools: wget, tar, cmake, debhelper

set -e


VERSION=2.26.5
LINK="https://www.libsdl.org/release/SDL2-${VERSION}.tar.gz"
ARCHIVE=/tmp/sdl2.tar.gz
SRC_DIR=../packages/libsdl2-dev


printf "libsdl2-dev ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$SRC_DIR"
dpkg-buildpackage -us -uc -b

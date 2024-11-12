#!/bin/bash
# Tools: cmake
# Dependencies: libpcre3-dev

set -e

VERSION=2.16.0
LINK="https://github.com/danmar/cppcheck/archive/${VERSION}.tar.gz"
ARCHIVE=/tmp/cppcheck.tar.gz
SRC_DIR=../packages/cppcheck


printf "cppcheck ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"

wget "$LINK" -O "$ARCHIVE"

tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$SRC_DIR"
dpkg-buildpackage -us -uc -b

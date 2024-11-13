#!/bin/bash
# Tools: wget, tar, debhelper
# Dependencies: libwebkit2gtk-4.1-dev

set -e

VERSION=3.7.0
LINK="https://github.com/fanglingsu/vimb/archive/${VERSION}.tar.gz"
ARCHIVE=/tmp/vimb.tar.gz
SRC_DIR=/tmp/vimb
DEB_DIR=../packages/vimb


printf "vimb ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

mkdir -p "$SRC_DIR"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

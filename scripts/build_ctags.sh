#!/bin/bash
# Tools: wget, unzip, autoconf, debhelper

set -e

VERSION=6.1.0
LINK="https://github.com/universal-ctags/ctags/archive/refs/tags/v${VERSION}.tar.gz"
ARCHIVE=/tmp/ctags.tar.gz
SRC_DIR=/tmp/ctags
DEB_DIR=../packages/ctags


printf "ctags ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

mkdir -p "$SRC_DIR"
tar -xzvf "$ARCHIVE" --directory "$SRC_DIR" --strip-components=1

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

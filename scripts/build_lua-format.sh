#!/bin/bash
# Tools: git, cmake

set -e

VERSION=1.3.6
LINK="https://github.com/Koihik/LuaFormatter.git"
ARCHIVE=/tmp/lt.tar.gz
TMP_DIR=/tmp/lf
SRC_DIR=../packages/lua-format
CHANGELOG="$SRC_DIR/debian/changelog"


printf "lua-format ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"


git clone --recurse-submodules "$LINK" "$TMP_DIR"
mv "$TMP_DIR/"* "$SRC_DIR/"

cd "$SRC_DIR"

dpkg-buildpackage -us -uc -b

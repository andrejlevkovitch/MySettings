#!/bin/bash
# Tools: git, cmake

set -e

VERSION=1.3.6
LINK="https://github.com/Koihik/LuaFormatter.git"
ARCHIVE=/tmp/lt.tar.gz
SRC_DIR=/tmp/lf
DEB_DIR=../packages/lua-format


printf "lua-format ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$DEB_DIR/debian/changelog"


git clone --recurse-submodules "$LINK" "$SRC_DIR"

cd "$DEB_DIR"
dpkg-buildpackage -us -uc -b

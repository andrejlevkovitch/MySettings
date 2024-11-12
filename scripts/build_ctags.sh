#!/bin/bash
# Tools: wget, unzip, autoconf, debhelper

set -e

VERSION=0.0.1
LINK="https://github.com/universal-ctags/ctags/archive/master.zip"
ARCHIVE=/tmp/ctags.zip
SRC_DIR=../packages/ctags-master


printf "ctags ($VERSION) UNRELEASED; urgency=medium\n\n  * Initial release. (Closes: #XXXXXX)\n\n -- Andrei Liaukovich <andrejlevkovitch@gmail.com>  $(date -R)\n" > "$SRC_DIR/debian/changelog"


wget "$LINK" -O "$ARCHIVE"

unzip $ARCHIVE -d ../packages
cd $SRC_DIR

dpkg-buildpackage -us -uc -b

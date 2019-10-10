#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_DIR=$(pwd)
HOME_DIR=$HOME
TMP_DIR=/tmp

CUR_SYSTEM=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

print_delim () {
  echo -------------------------------------------------------------------------
}

print_info () {
  echo -e ${GREEN}${1}${NC}
}

print_warn () {
  echo -e ${YELLOW}${1}${NC}
}

print_error () {
  echo -e ${RED}${1}${NC}
}

# @param 1 package name (will be added postfix `-ch`)
# @param 2 package version
# @param 3 install handler - not required
ch_install () {
  local PACKAGE=$1
  local VERSION=$2
  local HANDLER=$3

  if [ -z ${PACKAGE+x} ]; then
    print_error "package not set"
    return 1
  fi
  if [ -z ${VERSION+x} ]; then
    print_error "version not set"
    return 1
  fi

  checkinstall -D -y \
    --pkgname=$PACKAGE-ch \
    --pkgversion=$VERSION \
    --nodoc \
    --backup=no \
    --fstrans=no \
    --install=yes \
    $HANDLER

  return $?
}

# @brief load file. If caused some error - remove the file (if loaded) and return not 0 value
# @param 1 download link
# @param 2 name of loaded file
# @param 3 sha sum - not required
package_loader() {
  local DOWNLOAD_LINK=$1
  local OUT_FILE=$2
  local SHA_SUM=$3

  if [ -z ${DOWNLOAD_LINK+x} ]; then
    print_error "package not set"
    return 1
  fi
  if [ -z ${OUT_FILE+x} ]; then
    print_error "version not set"
    return 1
  fi

  wget $DOWNLOAD_LINK -O $OUT_FILE
  if ! [ -z ${SHA_SUM+x} ]; then
    echo "$SHA_SUM  $OUT_FILE" | sha256sum -c | grep -v OK
    if [ $? -eq 0 ]; then
      rm $OUT_FILE
      return 1
    fi
  fi

  return 0
}

check_package() {
  local PACKAGE=$1

  if [ -z ${PACKAGE+x} ]; then
    print_error "package not set"
    return 1
  fi

  dpkg -s $PACKAGE-ch
  return $?
}

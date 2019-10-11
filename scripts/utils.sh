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

  if ! [ -n "$PACKAGE" ]; then
    print_error "package not set"
    return 1
  fi
  if ! [ -n "$VERSION" ]; then
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

  if ! [ -n "$DOWNLOAD_LINK" ]; then
    print_error "package not set"
    return 1
  fi
  if ! [ -n "$OUT_FILE" ]; then
    print_error "version not set"
    return 1
  fi

  wget $DOWNLOAD_LINK -O $OUT_FILE
  if [ $? -ne 0 ]; then
    rm $OUT_FILE
    return 1
  fi
  if [ -n "$SHA_SUM" ]; then
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

  if ! [ -n "$PACKAGE" ]; then
    print_error "package not set"
    return 1
  fi

  dpkg -s $PACKAGE-ch
  return $?
}

check_root() {
  if [ $EUID -ne 0 ]; then
    print_error "you need start it as superuser"
    exit 1
  fi
}

check_user() {
  if [ $EUID -eq 0 ]; then
    print_error "you not need start it as superuser"
    exit 1
  fi
}

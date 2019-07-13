#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_DIR=$(pwd)
HOME_DIR=$HOME

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

#!/bin/bash
# Warn if you have installing apach - you have do disable it!

RED='\033[0;31m'
NC='\033[0m' # No Color

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
apt-get install -y \
  libmagic-dev \
  luajit libluajit-5.1-dev \
  lua5.1 liblua5.1-0-dev \
  lua-cjson lua-filesystem lua-socket \
  lua-nginx-redis
if [ $? -ne 0 ]; then
  echo -e $RED can not install needed packages for nginx $NC
  exit 1
fi

rm /etc/nginx/sites-enabled/default

systemctl restart nginx

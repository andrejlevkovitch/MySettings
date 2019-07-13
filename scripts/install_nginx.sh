#!/bin/bash
# Warn if you have installing apach - you have do disable it!

source utils.sh

print_delim

apt-get install -y \
  libmagic-dev \
  luajit libluajit-5.1-dev \
  lua5.1 liblua5.1-0-dev \
  lua-cjson lua-filesystem lua-socket \
  lua-nginx-redis
if [ $? -ne 0 ]; then
  print_error "can not install needed packages for nginx"
  exit 1
fi

rm /etc/nginx/sites-enabled/default

systemctl restart nginx

print_delim

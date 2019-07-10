#!/bin/bash
# Warn if you have installing apach - you have do disable it!

apt-get install -y \
  libmagic-dev \
  luajit libluajit-5.1-dev \
  lua5.1 liblua5.1-0-dev \
  lua-cjson lua-filesystem lua-socket \
  lua-nginx-redis
if [ $? -ne 0 ]; then
  echo can not install needed packages for nginx
fi

rm /etc/nginx/sites-enabled/default

systemctl restart nginx

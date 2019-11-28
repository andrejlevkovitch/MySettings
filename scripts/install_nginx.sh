#!/bin/bash
# Warn if you have installing apach - you have do disable it!
# XXX you can get error with restart nginx (or some other service) after
# reboot. Error happens if you set some aliases for host ip in /etc/hosts. For
# escape the error you need add next string to service config:
# - ExecStartPre=/bin/bash -c 'while ! ping -w 1 -c 1 micro > /dev/null; do sleep 1; done'

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

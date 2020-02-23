#!/bin/bash

source utils.sh

print_delim

apt-get install -y \
  dirmngr \
  gnupg
if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update
apt-get install -y \
  mongodb-org
if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi

# XXX mongod service not set enabled automaticly, so, if you need, just run it
# systemctl enable mongod.service
# systemctl start mongod.service

print_delim

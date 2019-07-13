#!/bin/bash

source utils.sh

print_delim

apt-get install -y \
  dirmngr
if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
apt-get update
apt-get install -y \
  mongodb-org
if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi

systemctl enable mongod.service
systemctl start mongod.service

print_delim

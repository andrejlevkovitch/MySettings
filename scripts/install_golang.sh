#!/bin/bash

source utils.sh

GO_VERSION=1.23


print_delim

print_info "Install go"

apt-get install -y "golang-$GO_VERSION"

if [ $? -ne 0 ]; then
  print_error "go can not be installed"
  exit 1
fi

print_info "Set alternatives for go"
update-alternatives --install \
          /usr/bin/go     go    /usr/lib/go-1.23/bin/go  60 \
  --slave /usr/bin/gofmt  gofmt /usr/lib/go-1.23/bin/gofmt

print_delim

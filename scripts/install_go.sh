#!/bin/bash

curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer

# it is needed for use go not only in your home directory
echo "ADD '$HOME/.go/bin' TO YOUR PATH IN .bashrc"

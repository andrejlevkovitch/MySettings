#!/bin/bash
# Install software neded for programming
# have to be run only after install_base_software.sh

source utils.sh

print_delim

print_info "Install software for programming"
apt-get install -y \
  git \
  doxygen graphviz \
  python3-dev python-dev \
  python3-pip \
  gdb \
  gdbserver \
  cppcheck \
  w3m \
  tree

if [ $? -ne 0 ]; then
  print_error "soft for programming can not be installed"
  exit 1
fi

print_delim

print_info "Install docker-ce"
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl

if [ "$CUR_SYSTEM" = "ubuntu" ]; then
  apt-get install -y gnupg-agent
elif [ "$CUR_SYSTEM" = "debian" ];then
  apt-get install -y gnupg2
else
  print_error "unsupported system: $CUR_SYSTEM"
  exit 1
fi

if [ $? -ne 0 ]; then
  print_error "soft for docker can not be installed"
  exit 1
fi


curl -fsSL https://download.docker.com/linux/$CUR_SYSTEM/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$CUR_SYSTEM \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io

if [ $? -ne 0 ]; then
  print_error "docker can not be installed"
  exit 1
fi


print_delim

bash $FILE_DIR/install_dev_soft_from_src.sh

print_delim


# For use docker without sudo add user to docker group
# $ sudo groupadd docker
# $ sudo usermod -aG docker $USER

# Install jenkins
# apt-get install -y \
#   openjdk-8-jdk \
#   ssh \
#   daemon
# wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
# sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
# sudo apt update
# sudo apt install jenkins

# Also you need enable ufw
# ufw allow 8080
# ufw allow OpenSSH
# ufw enable

# And do not forget about installation plugins for Jenkins, especially Xvfb !!!!

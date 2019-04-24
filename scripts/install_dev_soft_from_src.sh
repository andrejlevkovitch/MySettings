#!/bin/sh
# Compile and install soft for developing

CUR_DIR=$(pwd)
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo --------------------------------------------------------------------------

# if checkinstall not install
if [ ! -x "$(command -v checkinstall)" ]; then
  echo Install tool for installation
  apt-get install -y \
    checkinstall
fi

if [ ! -x "$(command -v automake)" ]; then
  echo Install automake
  apt-get install -y \
    automake
fi

if [ ! -x "$(command -v wget)" ]; then
  echo Install automake
  apt-get install -y \
    wget
fi


echo Prepare for install custom deb packages
# For vim, vifm and vimb
echo Install libraries for future packages
apt-get install -y \
  libncurses5-dev libncursesw5-dev \
  libgtk2.0-dev libgnomeui-dev libgnome2-dev \
  libbonoboui2-dev \
  libcairo2-dev \
  libatk1.0-dev \
  libx11-dev libxpm-dev libxt-dev \
  liblua5.3 liblua5.3-dev \
  libperl-dev \
  ruby-dev \
  xz-utils libpthread-workqueue-dev \
  libgtk-3-dev \
  libwebkit2gtk-4.0-dev \
  python3.5-dev \
  libcurl4-openssl-dev


echo Add links for lua
LUA_DIR=/usr/include/lua5.3
if [ ! -d $LUA_DIR/lib ]; then
  mkdir $LUA_DIR/lib
fi
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.so $LUA_DIR/lib/liblua.so
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.a  $LUA_DIR/lib/liblua.a
ln -sf $LUA_DIR                               $LUA_DIR/include


# go to /tmp dir
cd /tmp


# all packages have -ch at the end. It points that it from checkinstall
echo --------------------------------------------------------------------------

echo Install boost
wget "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz"
tar -xzvf boost_1_69_0.tar.gz
rm boost_1_69_0.tar.gz
cd boost_1_69_0

./bootstrap.sh
./b2
checkinstall -D -y --pkgname=boost-ch --pkgversion=1.69.0 --nodoc --backup=no ./b2 install

cd ..
rm -rf boost_1_69_0

echo --------------------------------------------------------------------------

echo Install cmake
wget "https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1.tar.gz"
tar -xzvf cmake-3.14.1.tar.gz
rm cmake-3.14.1.tar.gz
cd cmake-3.14.1

./bootstrap --system-curl
make -j4
checkinstall -D -y --pkgname=cmake-ch --pkgversion=3.14.1 --nodoc --backup=no

cd ..
rm -rf cmake-3.14.1

echo --------------------------------------------------------------------------

# need for vim (tagbar)
echo Install universal ctags
wget "https://github.com/universal-ctags/ctags/archive/master.zip"
unzip master.zip
rm master.zip

cd ctags-master
./autogen.sh
./configure
make -j4
# real version of universal-ctags is 0.0.0, but we can not set it as version in checkinstall
checkinstall -D -y --pkgname=ctags-ch --pkgversion=0.0.1 --nodoc --backup=no

cd ..
rm -rf ctags-master

echo --------------------------------------------------------------------------

echo Install vim
wget "https://github.com/vim/vim/archive/v8.1.1140.tar.gz"
tar -xzvf v8.1.1140.tar.gz
rm v8.1.1140.tar.gz
cd vim-8.1.1140

./configure --with-features=huge \
            --enable-luainterp=yes \
            --with-lua-prefix=/usr/include/lua5.3 \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
            --enable-rubyinterp=yes \
            --enable-perlinterp=yes \
            --enable-multibyte \
            --enable-gui=no \
            --enable-cscope \
            --enable-largefile \
            --disable-netbeans \
            --prefix=/usr/local
make -j4
checkinstall -D -y --pkgname=vim-ch --pkgversion=8.1.1140 --nodoc --backup=no

cd ..
rm -rf vim-8.1.1140

echo --------------------------------------------------------------------------

echo Install vifm
wget "https://github.com/vifm/vifm/archive/v0.10.tar.gz"
tar -xzvf v0.10.tar.gz
rm v0.10.tar.gz
cd vifm-0.10

./configure
make -j4
checkinstall -D -y --pkgname=vifm-ch --pkgversion=0.10 --nodoc --backup=no

cd ..
rm -rf vifm-0.10

echo --------------------------------------------------------------------------

echo Install vimb
wget "https://github.com/fanglingsu/vimb/archive/3.3.0.tar.gz"
tar -xzvf 3.3.0.tar.gz
rm 3.3.0.tar.gz
cd vimb-3.3.0

make -j4
checkinstall -D -y --pkgname=vimb-ch --pkgversion=3.3.0 --nodoc --backup=no

cd ..
rm -rf vimb-3.3.0

echo --------------------------------------------------------------------------

echo Install diff tool to git
cp $FILE_DIR/../git/git_diff_wrapper /usr/local/bin

echo Set vim as default editor
update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
update-alternatives --set editor /usr/local/bin/vim
update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
update-alternatives --set vi /usr/local/bin/vim

echo --------------------------------------------------------------------------

# go back
cd $CUR_DIR

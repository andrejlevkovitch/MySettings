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
  python3.5-dev


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
checkinstall ./b2 install  -D -y --pkgname=boost-ch

cd ..
rm boost_1_69_0 -rf

echo --------------------------------------------------------------------------

echo Install cmake
git clone https://github.com/Kitware/cmake.git

cd cmake
./bootstrap
make -j4
checkinstall -D -y --pkgname=cmake-ch

cd ..
rm cmake -rf

echo --------------------------------------------------------------------------

# need for vim (tagbar)
echo Install universal ctags
git clone https://github.com/universal-ctags/ctags.git

cd ctags
./autogen.sh
./configure
make -j4
checkinstall -D -y --pkgname=ctags-ch

cd ..
rm ctags -rf

echo --------------------------------------------------------------------------

echo Install vim
git clone https://github.com/vim/vim.git
cd vim

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
checkinstall -D -y --pkgname=vim-ch

cd ..
rm vim -rf

echo --------------------------------------------------------------------------

echo Install vifm
git clone https://github.com/vifm/vifm.git
cd vifm

./configure
make -j4
checkinstall -D -y --pkgname=vifm-ch

cd ..
rm vifm -rf

echo --------------------------------------------------------------------------

echo Install vimb
git clone https://github.com/fanglingsu/vimb.git
cd vimb

make -j4
checkinstall -D -y --pkgname=vimb-ch

cd ..
rm vimb -rf

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

#!/bin/sh
# Note: have to be run only after install_base_software.sh. Also you need installed cmake
# Note: you need have only one version of lua interpreter (see `color_coded` in `set_settings.sh`)

source utils.sh

print_delim

check_commands cmake checkinstall
if [ $? -ne 0 ]; then
  print_error "first you need install cmake and checkinstall"
  exit 1
fi


print_info "Install additional packages"
apt-get install -y \
  libncurses5-dev libncursesw5-dev \
  libcairo2-dev \
  liblua5.1-0 liblua5.1-0-dev \
  libperl-dev \
  ruby-dev \
  libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev \
  xz-utils \
  python3.7-dev \
  libcurl4-openssl-dev \
  libtinfo5

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi

print_delim

print_info "Add links for lua"
LUA_DIR=/usr/include/lua5.1
if [ ! -d $LUA_DIR/lib ]; then
  mkdir $LUA_DIR/lib
fi
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.1.so $LUA_DIR/lib/liblua.so
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.1.a  $LUA_DIR/lib/liblua.a
ln -sf $LUA_DIR                               $LUA_DIR/include

print_delim

CTAGS_PACKAGE=ctags
CTAGS_VERSION=0.0.1
CTAGS_LINK="https://github.com/universal-ctags/ctags/archive/master.zip"
CTAGS_ARCHIVE=$TMP_DIR/ctags_ar
CTAGS_DIR=$TMP_DIR/ctags-master

check_package $CTAGS_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $CTAGS_PACKAGE"

  package_loader $CTAGS_LINK $CTAGS_ARCHIVE
  if [ $? -ne 0 ]; then
    print_error "Can not load $CTAGS_PACKAGE"
    exit 1
  fi

  unzip $CTAGS_ARCHIVE -d $TMP_DIR
  rm $CTAGS_ARCHIVE
  cd $CTAGS_DIR

  ./autogen.sh
  ./configure
  make -j4

  ch_install $CTAGS_PACKAGE $CTAGS_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $CTAGS_DIR
    print_error "$CTAGS_PACKAGE can not be installed"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $CTAGS_DIR
fi

print_delim

VIM_PACKAGE=vim
VIM_VERSION=8.1.1140
VIM_LINK="https://github.com/vim/vim/archive/v8.1.1140.tar.gz"
VIM_SHA="b2bd214f9e562308af7203e3e8cfeb13327d503ab2fe23090db9c42f13ca0145"
VIM_ARCHIVE=vim_ar
VIM_DIR=vim_dir

check_package $VIM_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $VIM_PACKAGE"
  package_loader $VIM_LINK $VIM_ARCHIVE $VIM_SHA
  if [ $? -ne 0 ]; then
    print_error "Can not load $VIM_PACKAGE"
    exit 1
  fi

  mkdir $VIM_DIR
  tar -xzvf $VIM_ARCHIVE --directory $VIM_DIR --strip-components=1
  rm $VIM_ARCHIVE
  cd $VIM_DIR

  ./configure --with-features=huge \
              --enable-luainterp=yes \
              --with-lua-prefix=/usr/include/lua5.1 \
              --enable-python3interp=yes \
              --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
              --enable-rubyinterp=yes \
              --enable-perlinterp=yes \
              --enable-multibyte \
              --enable-gui=no \
              --enable-cscope \
              --enable-largefile \
              --disable-netbeans \
              --prefix=/usr/local
  make -j4

  ch_install $VIM_PACKAGE $VIM_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $VIM_DIR
    print_error "Can not install $VIM_PACKAGE"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $VIM_DIR
fi

print_delim

VIFM_PACKAGE=vifm
VIFM_VERSION=0.10
VIFM_LINK="https://github.com/vifm/vifm/archive/v0.10.tar.gz"
VIFM_SHA="e5681c9e560e23d9deeec3b5b12e0ccad82612d9592c00407f3dd75cf5066548"
VIFM_ARCHIVE=vifm_ar
VIFM_DIR=vifm_dir

check_package $VIFM_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install $VIFM_PACKAGE"
  package_loader $VIFM_LINK $VIFM_ARCHIVE $VIFM_SHA
  if [ $? -ne 0 ]; then
    print_error "Can not load $VIFM_PACKAGE"
    exit 1
  fi

  mkdir $VIFM_DIR
  tar -xzvf $VIFM_ARCHIVE --directory $VIFM_DIR --strip-components=1
  rm $VIFM_ARCHIVE
  cd $VIFM_DIR

  ./configure
  make -j4

  ch_install $VIFM_PACKAGE $VIFM_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $VIFM_DIR
    print_error "Can not install $VIFM_PACKAGE"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $VIFM_DIR
fi

print_delim

LF_PACKAGE=lua-format
LF_VERSION=1.2.2
LF_LINK="https://github.com/andrejlevkovitch/LuaFormatter/archive/master.zip"
LF_ARCHIVE=$TMP_DIR/lt_ar
LF_DIR=$TMP_DIR/LuaFormatter-master

check_package $LF_PACKAGE
if [ $? -ne 0 ]; then
  print_info "Install checkinstall"

  package_loader $LF_LINK $LF_ARCHIVE
  if [ $? -ne 0 ]; then
    print_error "Can not load $LF_PACKAGE"
    exit 1
  fi

  unzip $LF_ARCHIVE -d $TMP_DIR
  rm $LF_ARCHIVE
  cd $LF_DIR

  cmake .
  cmake --build . -- -j4

  ch_install $LF_PACKAGE $LF_VERSION
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $LF_DIR
    print_error "Can not install $LF_PACKAGE"
    exit 1
  fi

  cd $CUR_DIR
  rm -rf $LF_DIR
fi

print_delim

print_info "Install tool for formatting lua in vim"
git clone https://github.com/andrejlevkovitch/vim-lua-format.git
cp vim-lua-format/lua-format.py /usr/local/bin/
rm -rf vim-lua-format

print_info "Install tool for formatting python in vim"
git clone https://github.com/andrejlevkovitch/vim-python-format.git
cp vim-python-format/python-format.py /usr/local/bin/
rm -rf vim-python-format
pip3 install yapf
# TODO you also have to add yapf to PATH if it was installed to .local dir

print_info "Install diff tool to git"
cp $FILE_DIR/../git/git_diff_wrapper /usr/local/bin

print_info "copy syntax files for vim"
cp -f $FILE_DIR/../vim/syntax/* /usr/local/share/vim/vim81/syntax/

print_info "Set vim as default editor"
update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
update-alternatives --set editor /usr/local/bin/vim
update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
update-alternatives --set vi /usr/local/bin/vim

print_delim

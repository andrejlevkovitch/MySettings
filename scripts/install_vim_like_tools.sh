#!/bin/bash
# Note: have to be run only after install_base_software.sh. Also you need installed cmake

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
  libperl-dev \
  ruby-dev \
  libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev \
  xz-utils \
  python3.7-dev \
  libcurl4-openssl-dev \
  libtinfo5 \
  w3m

if [ $? -ne 0 ]; then
  print_error "neded packages can not be installed"
  exit 1
fi

print_delim

CTAGS_PACKAGE=ctags
CTAGS_VERSION=0.0.1
CTAGS_LINK="https://github.com/universal-ctags/ctags/archive/master.zip"
CTAGS_ARCHIVE=$TMP_DIR/ctags_ar
CTAGS_DIR=$TMP_DIR/ctags-master

FAILURE=false

check_package $CTAGS_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $CTAGS_PACKAGE"

    package_loader $CTAGS_LINK $CTAGS_ARCHIVE
    if [ $? -ne 0 ]; then
      print_error "Can not load $CTAGS_PACKAGE"
      FAILURE=true
      break
    fi

    unzip $CTAGS_ARCHIVE -d $TMP_DIR
    cd $CTAGS_DIR

    ./autogen.sh
    ./configure
    if [ $? -ne 0 ]; then
      print_error "Configuration error"
      FAILURE=true
      break
    fi

    make -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation error"
      FAILURE=true
      break
    fi

    ch_install $CTAGS_PACKAGE $CTAGS_VERSION
    if [ $? -ne 0 ]; then
      print_error "$CTAGS_PACKAGE can not be installed"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm $CTAGS_ARCHIVE
rm -rf $CTAGS_DIR

if $FAILURE; then
  exit 1
fi

print_delim

VIM_PACKAGE=vim
VIM_VERSION=8.2.0012
VIM_LINK="https://github.com/vim/vim/archive/v$VIM_VERSION.tar.gz"
VIM_SHA="d1ebe8232fcd8bc0d97c7560a1f407efc6ee65865353bd01d79b6a23b85b1d5f"
VIM_ARCHIVE=vim_ar
VIM_DIR=vim_dir

FAILURE=false

check_package $VIM_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $VIM_PACKAGE"
    package_loader $VIM_LINK $VIM_ARCHIVE $VIM_SHA
    if [ $? -ne 0 ]; then
      print_error "Can not load $VIM_PACKAGE"
      FAILURE=true
      break
    fi

    mkdir $VIM_DIR
    tar -xzvf $VIM_ARCHIVE --directory $VIM_DIR --strip-components=1
    cd $VIM_DIR

    ./configure --with-features=huge \
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
    if [ $? -ne 0 ]; then
      print_error "Configuration error"
      FAILURE=true
      break
    fi

    make -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation error"
      FAILURE=true
      break
    fi

    ch_install $VIM_PACKAGE $VIM_VERSION
    if [ $? -ne 0 ]; then
      print_error "Can not install $VIM_PACKAGE"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm $VIM_ARCHIVE
rm -rf $VIM_DIR

if $FAILURE; then
  exit 1
fi

print_delim

VIFM_PACKAGE=vifm
VIFM_VERSION=0.10
VIFM_LINK="https://github.com/vifm/vifm/archive/v0.10.tar.gz"
VIFM_SHA="e5681c9e560e23d9deeec3b5b12e0ccad82612d9592c00407f3dd75cf5066548"
VIFM_ARCHIVE=vifm_ar
VIFM_DIR=vifm_dir

FAILURE=false

check_package $VIFM_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install $VIFM_PACKAGE"
    package_loader $VIFM_LINK $VIFM_ARCHIVE $VIFM_SHA
    if [ $? -ne 0 ]; then
      print_error "Can not load $VIFM_PACKAGE"
      FAILURE=true
      break
    fi

    mkdir $VIFM_DIR
    tar -xzvf $VIFM_ARCHIVE --directory $VIFM_DIR --strip-components=1
    cd $VIFM_DIR

    ./configure
    if [ $? -ne 0 ]; then
      print_error "Configuration failed"
      FAILURE=true
      break
    fi

    # XXX gcc-10 can't compile this project, use CC=gcc-9 (or less)
    make -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation failed"
      FAILURE=true
      break
    fi

    ch_install $VIFM_PACKAGE $VIFM_VERSION
    if [ $? -ne 0 ]; then
      print_error "Can not install $VIFM_PACKAGE"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm $VIFM_ARCHIVE
rm -rf $VIFM_DIR

if $FAILURE; then
  exit 1
fi

print_delim

LF_PACKAGE=lua-format
LF_VERSION=1.2.2
LF_LINK="https://github.com/andrejlevkovitch/LuaFormatter.git"
LF_ARCHIVE=$TMP_DIR/lt_ar
LF_DIR=$TMP_DIR/LuaFormatter-master

FAILURE=false

check_package $LF_PACKAGE
if [ $? -ne 0 ]; then
  for i in [1]; do
    print_info "Install checkinstall"

    git clone --recurse-submodules $LF_LINK $LF_DIR
    if [ $? -ne 0 ]; then
      print_error "Can not load $LF_PACKAGE"
      FAILURE=true
      break
    fi

    cd $LF_DIR
    mkdir build
    cd build
    cmake ..
    if [ $? -ne 0 ]; then
      print_error "Configuration failed"
      FAILURE=true
      break
    fi

    cmake --build . -- -j4
    if [ $? -ne 0 ]; then
      print_error "Compilation failed"
      FAILURE=true
      break
    fi

    ch_install $LF_PACKAGE $LF_VERSION
    if [ $? -ne 0 ]; then
      print_error "Can not install $LF_PACKAGE"
      FAILURE=true
      break
    fi
  done
fi

cd $CUR_DIR
rm -rf $LF_ARCHIVE
rm -rf $LF_DIR

if $FAILURE; then
  exit 1
fi

print_delim

# tool for formatting python code
apt-get install -y yapf

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

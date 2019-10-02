#!/bin/bash
# This can be run by user without root
# Only after install_pkgs script!

source utils.sh

print_delim

print_info "Downloads vim plugins"
cp $FILE_DIR/../vim/.vimrc $HOME_DIR/
if [ ! -d $HOME_DIR/.vim ]; then
  mkdir $HOME_DIR/.vim
  mkdir $HOME_DIR/.vim/bundle
fi
if [ ! -d $HOME_DIR/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME_DIR/.vim/bundle/Vundle.vim/
fi

vim +PluginInstall +qall

if [ $? -ne 0 ]; then
  print_error "vim can not load plugins"
  exit 1
fi

python3 $HOME_DIR/.vim/bundle/YouCompleteMe/install.py --clang-completer

if [ $? -ne 0 ]; then
  cd $CUR_DIR
  print_error "YCM can not be installed"
  exit 1
fi

# NOTE: color_coded must be compiled with save version of lua with witch
# compiled vim. BUT! if you have several versions of lua can be founded not
# needed version. So be careful. In this case you will get SEGMENTATION FAULT
if [ ! -d $HOME_DIR/.vim/bundle/color_coded/build ]; then
  mkdir $HOME_DIR/.vim/bundle/color_coded/build
fi
cd $HOME_DIR/.vim/bundle/color_coded/build
cmake ..
cmake --build . --target install -- -j4

if [ $? -ne 0 ]; then
  cd $CUR_DIR
  print_error "color_coded can not be compiled"
  exit 1
fi
cd $CUR_DIR

print_info "Install needed config files for vim"
cp $FILE_DIR/../vim/color_coded.vim $HOME_DIR/.vim/bundle/color_coded/after/syntax
cp $FILE_DIR/../vim/.ycm_extra_conf.py $HOME_DIR/.vim/
cp $FILE_DIR/../vim/.color_coded $HOME_DIR/

print_info "Install vimb config"
if [ ! -d $HOME_DIR/.config/vimb ]; then
  mkdir $HOME_DIR/.config/vimb/
fi
cp $FILE_DIR/../vimb/* $HOME_DIR/.config/vimb/

print_info "Install config for git"
cp $FILE_DIR/../git/.gitconfig $HOME/

print_info "Install config for gdb"
cp $FILE_DIR/../gdb/.gdbinit $HOME_DIR
if [ ! -d $HOME_DIR/.gdb ]; then
  mkdir $HOME_DIR/.gdb
fi
git clone https://github.com/Lekensteyn/qt5printers.git $HOME_DIR/.gdb/qt5printers

print_info "Install config for w3m"
if [ ! -d $HOME_DIR/.w3m ]; then
  mkdir $HOME_DIR/.w3m
fi
cp $FILE_DIR/../w3m/* $HOME_DIR/.w3m

cd $CUR_DIR

print_delim

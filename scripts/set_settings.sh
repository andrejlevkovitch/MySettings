#!/bin/bash
# This can be run by user without root
# Only after install_pkgs script!

CUR_DIR=$(pwd)
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
HOME_DIR=$HOME

echo -------------------------------------------------------------------------

echo Downloads vim plugins
cp $FILE_DIR/../vim/.vimrc $HOME_DIR/
if [ ! -d $HOME_DIR/.vim ]; then
  mkdir $HOME_DIR/.vim
  mkdir $HOME_DIR/.vim/bundle
fi
if [ ! -d $HOME_DIR/.vim/bundle ]; then
  mkdir $HOME_DIR/.vim/bundle
fi
if [ ! -d $HOME_DIR/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME_DIR/.vim/bundle/Vundle.vim/
fi

vim +PluginInstall +qall

$HOME_DIR/.vim/bundle/YouCompleteMe/./install.py --clang-completer
if [ ! -d $HOME_DIR/.vim/bundle/color_coded/build ]; then
  mkdir $HOME_DIR/.vim/bundle/color_coded/build
fi
cd $HOME_DIR/.vim/bundle/color_coded/build
cmake ..
cmake --build . -- -j4
cmake --build . --target  install
cd $CUR_DIR

echo Install needed config files for vim
cp $FILE_DIR/../vim/UltiSnips $HOME_DIR/.vim/ -rf
cp $FILE_DIR/../vim/color_coded.vim $HOME_DIR/.vim/bundle/color_coded/after/syntax

echo Install vimb config
if [ ! -d $HOME_DIR/.config/vimb ]; then
  mkdir $HOME_DIR/.config/vimb/
fi
cp $FILE_DIR/../vimb/* $HOME_DIR/.config/vimb/

echo Install config for git
cp $FILE_DIR/../git/.gitconfig $HOME/

echo Install config for gdb
cp $FILE_DIR/../gdb/.gdbinit $HOME_DIR
if [ ! -d $HOME_DIR/.gdb ]; then
  mkdir $HOME_DIR/.gdb
fi
git clone https://github.com/Lekensteyn/qt5printers.git $HOME_DIR/.gdb/qt5printers

echo Install config for w3m
if [ ! -d $HOME_DIR/.w3m ]; then
  mkdir $HOME_DIR/.w3m
fi
cp $FILE_DIR/../w3m/* $HOME_DIR/.w3m

cd $CUR_DIR

echo -------------------------------------------------------------------------

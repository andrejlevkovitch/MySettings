#!/bin/bash
# This can be run by user without root
# Only after install_pkgs script!

source utils.sh

print_delim

print_info "Downloads vim plugins"
cp $FILE_DIR/../vim/.vimrc $HOME_DIR/
if [ ! -d $HOME_DIR/.vim ]; then
  mkdir -p $HOME_DIR/.vim/bundle
fi
if [ ! -d $HOME_DIR/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME_DIR/.vim/bundle/Vundle.vim/
fi

vim +PluginInstall +qall

if [ $? -ne 0 ]; then
  print_error "vim can not load plugins"
  exit 1
fi

python3 $HOME_DIR/.vim/bundle/YouCompleteMe/install.py --clangd-completer --go-completer --rust-completer

if [ $? -ne 0 ]; then
  cd $CUR_DIR
  print_error "YCM can not be installed"
  exit 1
fi

# compile hl-server
mkdir -p ~/.vim/bundle/vim-hl-client/build
cd ~/.vim/bundle/vim-hl-client/build
cmake ..
cmake --build . -- -j4

if [ $? -ne 0 ]; then
  cd $CUR_DIR
  print_error "hl-server was not compiled"
  exit 1
fi

print_info "Install vimb config"
if [ ! -d $HOME_DIR/.config/vimb ]; then
  mkdir $HOME_DIR/.config/vimb/
fi
cp $FILE_DIR/../vimb/* $HOME_DIR/.config/vimb/

print_info "Install config for git"
cp $FILE_DIR/../git/.gitconfig $HOME/

cd $CUR_DIR

print_delim

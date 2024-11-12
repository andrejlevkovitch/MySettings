#!/bin/bash
# Install newest gcc and clang compilers
# have to be run only after install_base_software.sh

source utils.sh

# if you need other version of gcc just set it here
GCC_VERSION=12

# if you need other version of clang just set it here
CLANG_VERSION=19
CLANG_REPO_DEB="deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-$CLANG_VERSION main"
CLANG_REPO_SRC="deb-src http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-$CLANG_VERSION main"

print_delim

print_info "Install gnu"
apt-get update
apt-get upgrade -y

if [ $? -ne 0 ]; then
  print_error "system can not be upgraded"
  exit 1
fi

apt-get install -y \
  gcc-$GCC_VERSION g++-$GCC_VERSION

if [ $? -ne 0 ]; then
  print_error "gnu can not be installed"
  exit 1
fi

print_info "Set alternatives for gcc"
update-alternatives --install \
          /usr/bin/gcc             gcc              /usr/bin/gcc-$GCC_VERSION  60 \
  --slave /usr/bin/g++             g++              /usr/bin/g++-$GCC_VERSION

print_delim

print_info "Install llvm"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
add-apt-repository -y "$CLANG_REPO_DEB"
apt-get update
apt-get upgrade -y

if [ $? -ne 0 ]; then
  print_error "system can not be upgraded"
  exit 1
fi

apt-get install -y \
  clang-$CLANG_VERSION \
  clang-format-$CLANG_VERSION \
  clang-tidy-$CLANG_VERSION \
  lld-$CLANG_VERSION \
  libclang-$CLANG_VERSION-dev \
  llvm-$CLANG_VERSION \
  llvm-$CLANG_VERSION-dev \
  llvm-$CLANG_VERSION-tools \
  libc++-$CLANG_VERSION-dev \
  libc++abi-$CLANG_VERSION-dev

if [ $? -ne 0 ]; then
  print_error "llvm can not be installed"
  exit 1
fi

print_info "Set alternatives for clang"
update-alternatives --install \
        /usr/bin/llvm-config       llvm-config      /usr/bin/llvm-config-$CLANG_VERSION  200 \
--slave /usr/bin/llvm-ar           llvm-ar          /usr/bin/llvm-ar-$CLANG_VERSION \
--slave /usr/bin/llvm-as           llvm-as          /usr/bin/llvm-as-$CLANG_VERSION \
--slave /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  /usr/bin/llvm-bcanalyzer-$CLANG_VERSION \
--slave /usr/bin/llvm-cov          llvm-cov         /usr/bin/llvm-cov-$CLANG_VERSION \
--slave /usr/bin/llvm-diff         llvm-diff        /usr/bin/llvm-diff-$CLANG_VERSION \
--slave /usr/bin/llvm-dis          llvm-dis         /usr/bin/llvm-dis-$CLANG_VERSION \
--slave /usr/bin/llvm-dwarfdump    llvm-dwarfdump   /usr/bin/llvm-dwarfdump-$CLANG_VERSION \
--slave /usr/bin/llvm-extract      llvm-extract     /usr/bin/llvm-extract-$CLANG_VERSION \
--slave /usr/bin/llvm-link         llvm-link        /usr/bin/llvm-link-$CLANG_VERSION \
--slave /usr/bin/llvm-mc           llvm-mc          /usr/bin/llvm-mc-$CLANG_VERSION \
--slave /usr/bin/llvm-mcmarkup     llvm-mcmarkup    /usr/bin/llvm-mcmarkup-$CLANG_VERSION \
--slave /usr/bin/llvm-nm           llvm-nm          /usr/bin/llvm-nm-$CLANG_VERSION \
--slave /usr/bin/llvm-objdump      llvm-objdump     /usr/bin/llvm-objdump-$CLANG_VERSION \
--slave /usr/bin/llvm-ranlib       llvm-ranlib      /usr/bin/llvm-ranlib-$CLANG_VERSION \
--slave /usr/bin/llvm-readobj      llvm-readobj     /usr/bin/llvm-readobj-$CLANG_VERSION \
--slave /usr/bin/llvm-rtdyld       llvm-rtdyld      /usr/bin/llvm-rtdyld-$CLANG_VERSION \
--slave /usr/bin/llvm-size         llvm-size        /usr/bin/llvm-size-$CLANG_VERSION \
--slave /usr/bin/llvm-stress       llvm-stress      /usr/bin/llvm-stress-$CLANG_VERSION \
--slave /usr/bin/llvm-symbolizer   llvm-symbolizer  /usr/bin/llvm-symbolizer-$CLANG_VERSION \
--slave /usr/bin/llvm-tblgen       llvm-tblgen      /usr/bin/llvm-tblgen-$CLANG_VERSION

update-alternatives --install\
        /usr/bin/clang             clang            /usr/bin/clang-$CLANG_VERSION     50 \
--slave /usr/bin/clangd            clangd            /usr/bin/clangd-$CLANG_VERSION \
--slave /usr/bin/clang++           clang++          /usr/bin/clang++-$CLANG_VERSION  \
--slave /usr/bin/lldb              lldb             /usr/bin/lldb-$CLANG_VERSION \
--slave /usr/bin/lldb-server       lldb-server      /usr/bin/lldb-server-$CLANG_VERSION \
--slave /usr/bin/lld               lld              /usr/bin/lld-$CLANG_VERSION \
--slave /usr/bin/ld.lld            ld-lld           /usr/bin/ld.lld-$CLANG_VERSION \
--slave /usr/bin/clang-format      clang-format     /usr/bin/clang-format-$CLANG_VERSION \
--slave /usr/bin/clang-tidy        clang-tidy       /usr/bin/clang-tidy-$CLANG_VERSION \
--slave /usr/bin/run-clang-tidy    run-clang-tidy   /usr/bin/run-clang-tidy-$CLANG_VERSION \
--slave /usr/bin/run-clang-tidy.py run-clang-tidy.py /usr/bin/run-clang-tidy-$CLANG_VERSION.py \
--slave /usr/bin/clang-apply-replacements clang-apply-replacements /usr/bin/clang-apply-replacements-$CLANG_VERSION

update-alternatives --install\

print_delim

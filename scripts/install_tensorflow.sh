#!/bin/bash
# TODO not well tested
# NOTE: for install tensorflow you need set some params during configuration

source utils.sh

print_delim

print_info "install soft for TensorFlow building"

apt-get install -y \
  python3 python3-dev python3-pip \
  pkg-config zip g++ zlib1g-dev unzip

if [ $? -ne 0 ]; then
  print_error "needed packages can not be installed"
  exit 1
fi

pip install future
if [ $? -ne 0 ]; then
  print_error "needed python modules can not be installed"
  exit 1
fi

print_delim

print_info "install bazel"
BAZEL=bazel
BAZEL_SHA="488d6b7223a1b3db965b8831c562aba61229a690aad38d75cd8f43012fc04fe4"
BAZEL_LINK="https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-installer-linux-x86_64.sh"
BAZEL_FILE=$TMP_DIR/bazel_installer
BAZEL_DIR=$TMP_DIR/bazel_dir

package_loader $BAZEL_LINK $BAZEL_FILE $BAZEL_SHA
if [ $? -ne 0 ]; then
  print_error "$BAZEL can not be loaded"
  exit 1
fi

bash $BAZEL_FILE --prefix=$BAZEL_DIR
if [ $? -ne 0 ]; then
  rm $BAZEL_FILE
  print_error "$BAZEL can not be installed"
  exit 1
fi
rm $BAZEL_FILE
export PATH=$BAZEL_DIR/bin:$PATH

print_delim

check_package $PACKAGE
if [ $? -ne 0 ]; then
  PACKAGE=tensorflow
  DOWNLOAD_LINK="https://github.com/tensorflow/tensorflow/archive/v2.0.0-rc1.tar.gz"
  SHA_SUM="dc0ac7f55cd5bffe39d0dc3727e03f311ca9e8395e041f88e0fa7d50a32830a2"
  VERSION=2.0.0
  ARCHIVE=$TMP_DIR/tensorflow_archive
  OUT_DIR=$TMP_DIR/tensorflow_dir

  package_loader $DOWNLOAD_LINK $ARCHIVE $SHA_SUM
  if [ $? -ne 0 ]; then
    rm -rf $BAZEL_DIR
    print_error "$PACKAGE can not be loaded"
    exit 1
  fi

  mkdir $OUT_DIR
  tar -xzvf $ARCHIVE --directory $OUT_DIR --strip-components=1
  rm $ARCHIVE
  cd $OUT_DIR

  ./configure #here you need manually set some params
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
    rm -rf $BAZEL_DIR
    rm -rf $OUT_DIR
    print_error "can not configure $PACKAGE"
    exit 1
  fi

  bazel build --config=v2 --config=cuda //tensorflow:libtensorflow_cc.so
  if [ $? -ne 0 ]; then
    cd $CUR_DIR
   #rm -rf $BAZEL_DIR
   #rm -rf $OUT_DIR
    print_error "$PACKAGE can not be compiled"
    exit 1
  fi

# ch_install $PACKAGE $VERSION
# if [ $? -ne 0 ]; then
#   cd $CUR_DIR
#   rm -rf $OUT_DIR
#   print_error "$PACKAGE can not be installed"
#   exit 1
# fi

  cd $CUR_DIR
# rm -rf $OUT_DIR
fi

print_delim

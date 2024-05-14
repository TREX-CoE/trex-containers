#!/bin/bash -e

cd /opt
source environment.sh

# Install dependencies
# --------------------

APT_REQUIRED="bash python3 vim-nox emacs-nox"
APT_NOT_REQUIRED="git wget curl unzip make bzip2 libzmq3-dev python3-pip m4 mlocate\
              autotools-dev pkg-config libhdf5-dev libzmq3-dev"

apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

if [ -d /opt/qp2 ] ; then
  :
else
  git clone https://github.com/QuantumPackage/qp2.git \
          --branch=master --depth=1 --shallow-submodules

  cd /opt/qp2
  ./configure -i all
  cd /opt
fi

source /opt/qp2/quantum_package.rc

pip install trexio

git clone https://github.com/trex-coe/qmcchem2.git \
          --branch=master --depth=1 --shallow-submodules

cd /opt/qmcchem2

./configure --prefix=/usr
make -j
make install

# Test

ls /usr/bin/qmc || exit 1
ls /usr/bin/qmcchem || exit 1


# Cleaning to reduce the size of the image
# ----------------------------------------

rm -rf /opt/qmcchem2

cd /opt/qp2/external
rm -rf f77-zmq* qmckl* opampack gmp trexio* zeromq* zlib* qp2-dependencies

cd /opt/qp2
rm -rf docs drone guix

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


#!/bin/bash -e

cd /opt
source environment.sh

# Install dependencies
# --------------------

APT_REQUIRED="bash python3 vim-nox emacs-nox"
APT_NOT_REQUIRED="git wget curl unzip make bzip2 libzmq3-dev python3-pip m4 mlocate\
              autoconf iproute2 autotools-dev pkg-config libhdf5-dev libzmq3-dev"

apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

git clone https://github.com/QuantumPackage/qp2.git \
        --branch=master --depth=1 --shallow-submodules

cd /opt/qp2

./configure -i all
pip install trexio

if [ $ARCH = x86_64 ] ; then

  ./configure -c ./config/ifort_2021_rome.cfg

elif [ $ARCH = aarch64 ] ; then

  ./configure -c ./config/gfortran.cfg

fi

source quantum_package.rc
ninja

if [ x.$INSTALL_QMCCHEM = x.yes ] ; then
    qp plugins download https://gitlab.com/scemama/qp_plugins_scemama
    qp plugins install qmcchem
    ninja

    cd /opt
    git clone https://github.com/trex-coe/qmcchem2.git \
    	  --branch=master --depth=1 --shallow-submodules

    cd /opt/qmcchem2
    ./autogen.sh

    ./configure
    source qmcchemrc
    make -j
    make clean-irpf90
    cd /opt/qp2
fi

ninja tidy

# Test

ls /opt/qp2/src/hartree_fock/scf || exit 1
ls /opt/qp2/ocaml/qp_run || exit 1
ls /opt/qp2/ocaml/qp_edit || exit 1


# Cleaning to reduce the size of the image
# ----------------------------------------

cd /opt/qp2/external
rm -rf f77-zmq* qmckl* opampack gmp trexio* zeromq* zlib* qp2-dependencies

cd /opt/qp2
rm -rf docs drone guix

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


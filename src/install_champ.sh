#!/bin/bash -e

cd /opt
source environment.sh

ln -s /usr/bin/python3 /usr/bin/python || :

# Install dependencies
# --------------------

APT_REQUIRED="python3"
APT_NOT_REQUIRED="cmake git make"
apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

git clone --depth=1 https://github.com/filippi-claudia/champ.git

cd champ

if [ $ARCH = x86_64 ] ; then

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="mpiifort" \
      -DENABLE_TREXIO=ON \
      -DENABLE_QMCKL=ON \
      -DVECTORIZATION="avx2"

elif [ $ARCH = aarch64 ] ; then

  export OMPI_ALLOW_RUN_AS_ROOT=1
  export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="mpif90" \
      -DENABLE_TREXIO=ON \
      -DENABLE_QMCKL=ON

fi

cmake --build build -j 8

# Test

ls bin/vmc.mov1 || exit 1
ls bin/dmc.mov1 || exit 1


# Clean up
rm -rf compile-* docs tests build lib

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


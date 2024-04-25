#!/bin/bash -e

cd /opt
source environment.sh

ln -sf /usr/bin/python3 /usr/bin/python || :

# Install dependencies
# --------------------

apt install -y cmake python3 git make gcc g++

git clone --depth=1 https://github.com/sissaschool/turborvb.git

cd turborvb

if [ $ARCH = x86_64 ] ; then
  echo "-march=core-avx2" >> /opt/ifort.cfg
  echo "-march=core-avx2" >> /opt/icx.cfg

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="ifort" \
      -DCMAKE_C_COMPILER="icx" \
      -DEXT_SERIAL="ON" \
      -DEXT_PARALLEL="ON" \
      -DEXT_OPT="ON"

# This was not tested yet
elif [ $ARCH = aarch64 ] ; then

  apt install -y openmpi-bin libopenmpi-dev

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="ifort" \
      -DCMAKE_C_COMPILER="icx" \
      -DEXT_SERIAL="ON" \
      -DEXT_PARALLEL="ON" \
      -DEXT_OPT="ON"

fi

cmake --build build -j 8

# Test
cmake --build build --target test

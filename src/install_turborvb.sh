#!/bin/bash -e

cd /opt
source environment.sh

ln -sf /usr/bin/python3 /usr/bin/python || :

# Install dependencies
# --------------------

APT_REQUIRED="python3 bc"
APT_NOT_REQUIRED="cmake git make gcc g++"
apt install -y $APT_NOT_REQUIRED $APT_REQUIRED

git clone --depth=1 https://github.com/sissaschool/turborvb.git turbo_src

cd turbo_src

if [ $ARCH = x86_64 ] ; then
  echo "-march=core-avx2" >> /opt/ifort.cfg
  echo "-march=core-avx2" >> /opt/icx.cfg

  cmake -S. -Bbuild \
      -DCMAKE_INSTALL_PREFIX="/opt/turborvb" \
      -DCMAKE_Fortran_COMPILER="ifort" \
      -DCMAKE_C_COMPILER="icx" \
      -DEXT_SERIAL="ON" \
      -DEXT_PARALLEL="ON" \
      -DEXT_OPT="ON"

# This was not tested yet
elif [ $ARCH = aarch64 ] ; then

  APT_REQUIRED="$APT_REQUIRED libopenblas0 openmpi-bin"
  APT_NOT_REQUIRED="$APT_NOT_REQUIRED libopenblas-serial-dev libopenmpi-dev"
  apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

  export OMPI_ALLOW_RUN_AS_ROOT=1
  export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

  cmake -S. -Bbuild \
      -DCMAKE_INSTALL_PREFIX="/opt/turborvb" \
      -DCMAKE_Fortran_COMPILER="gfortran" \
      -DCMAKE_C_COMPILER="gcc" \
      -DEXT_SERIAL="ON" \
      -DEXT_PARALLEL="ON" \
      -DEXT_OPT="ON"

fi

cmake --build build -j 8

# Test
cmake --build build --target test

# Install in /opt/turborvb
cmake --build build --target install
cp -f bin/*.sh bin/*.py /opt/turborvb/bin/


# Clean up compilation files
rm -rf /opt/turbo_src
rm -rf /opt/turborvb/test_tools/
rm -rf /opt/turborvb/lib/

# Clean up

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required

#!/bin/bash -e

cd /opt
source environment.sh

# Install dependencies
# --------------------

APT_REQUIRED="python3 gnuplot"
APT_NOT_REQUIRED="cmake git make"
apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

git clone --depth=1 https://github.com/ghb24/NECI_STABLE.git


mv NECI_STABLE neci
cd /opt/neci

if [ $ARCH = x86_64 ] ; then

  sed -i "s/-xHost//" ./cmake/compiler_flags/Intel_Fortran.cmake
  sed -i "s/-xHost//" ./cmake/compiler_flags/Intel_C.cmake
  sed -i "s/-xHost//" ./cmake/compiler_flags/Intel_CXX.cmake

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="mpiifort" \
      -DCMAKE_C_COMPILER="mpiicx" \
      -DCMAKE_CXX_COMPILER="mpiicpx" \
      -DENABLE_HDF5=ON \
      -DENABLE_BUILD_HDF5=ON

elif [ $ARCH = aarch64 ] ; then

  APT_REQUIRED="openmpi-bin"
  APT_NOT_REQUIRED="libopenmpi-dev"
  apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

  sed -i "s/-march=native -mtune=native/-march=armv8-a/" ./cmake/compiler_flags/GNU_Fortran.cmake

  export OMPI_ALLOW_RUN_AS_ROOT=1
  export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

  cmake -S. -Bbuild --debug-find \
      -DCMAKE_Fortran_COMPILER="/usr/bin/mpifort.openmpi" \
      -DCMAKE_C_COMPILER="/usr/bin/mpicc.openmpi" \
      -DCMAKE_CXX_COMPILER="/usr/bin/mpicxx.openmpi" \
      -DENABLE_HDF5=ON \
      -DENABLE_BUILD_HDF5=ON

fi

cmake --build build -j 8

mkdir bin
mv build/bin/neci bin/

# Test


ls bin/neci || exit 1

# Clean up
rm -rf compile-* docs tests build lib

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


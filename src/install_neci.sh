#!/bin/bash -e

cd /opt
source environment.sh

# Install dependencies
# --------------------

APT_REQUIRED="python3 gnuplot"
APT_NOT_REQUIRED="cmake git make"
apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

git clone --depth=1 https://github.com/ghb24/NECI_STABLE.git


cd NECI_STABLE

if [ $ARCH = x86_64 ] ; then

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="mpiifort" \
      -DENABLE_C_COMPILER="mpiicx" \
      -DENABLE_CXX_COMPILER="mpiicpx" \
      -DENABLE_HDF5=ON \
      -DENABLE_BUILD_HDF5=ON

elif [ $ARCH = aarch64 ] ; then

  export OMPI_ALLOW_RUN_AS_ROOT=1
  export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

  cmake -S. -Bbuild \
      -DCMAKE_Fortran_COMPILER="mpifort" \
      -DENABLE_C_COMPILER="mpicc" \
      -DENABLE_CXX_COMPILER="mpicxx" \
      -DENABLE_HDF5=ON \
      -DENABLE_BUILD_HDF5=ON

fi

cmake --build build -j 8

# Test

ls bin/vmc.mov1 || exit 1
ls bin/dmc.mov1 || exit 1


# Clean up
rm -rf compile-* docs tests build lib

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


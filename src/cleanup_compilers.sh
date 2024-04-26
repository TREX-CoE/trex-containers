#!/bin/bash -e

if [ $ARCH = "x86_64" ] ; then

  apt remove -y \
    intel-oneapi-compiler-dpcpp-cpp \
    intel-oneapi-compiler-fortran \
    intel-oneapi-mpi-devel \
    gcc g++ gfortran

  rm -f /opt/icx.cfg /opt/ifort.cfg
  rm -rf /opt/intel/oneapi/compiler/*/bin/


elif [ $ARCH = "aarch64" ] ; then

  apt remove -y gcc g++ gfortran libopenblas-dev libopenmpi-dev

else

  exit 1

fi

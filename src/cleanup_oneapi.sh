#!/bin/bash -e

apt remove -y \
   intel-oneapi-compiler-dpcpp-cpp \
   intel-oneapi-compiler-fortran \
   intel-oneapi-mpi-devel \
   gcc gfortran

rm -f /opt/icx.cfg /opt/ifort.cfg

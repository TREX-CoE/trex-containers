#!/bin/bash -e

cd /opt
source environment.sh

apt install -y wget pgpgpg

wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor \
| tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
| tee /etc/apt/sources.list.d/oneAPI.list

apt update

#apt install -y libmkl-rt
apt install -y intel-oneapi-compiler-fortran \
               intel-oneapi-compiler-fortran-runtime \
               intel-oneapi-compiler-dpcpp-cpp \
               intel-oneapi-compiler-dpcpp-cpp-runtime \
               intel-oneapi-openmp \
               intel-oneapi-mpi \
               intel-oneapi-mpi-devel \
               intel-oneapi-mkl-classic


ln -s /opt/intel/oneapi/compiler/latest/bin/ifort.cfg /opt/ifort.cfg
ln -s /opt/intel/oneapi/compiler/latest/bin/icx.cfg   /opt/icx.cfg

echo "-diag-disable=10448" > /opt/ifort.cfg

# Test

cd /opt
source environment.sh
ifort --version || exit 1
icx --version || exit 1
mpirun hostname || exit 1

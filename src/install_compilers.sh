#!/bin/bash -e

cd /opt
source environment.sh

if [ $ARCH = x86_64 ] ; then

  APT_NOT_REQUIRED="wget pgpgpg"
  apt install -y $APT_NOT_REQUIRED

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
  echo "-march=core-avx2" >> /opt/ifort.cfg
  echo "-march=core-avx2" >> /opt/icx.cfg

  # Test

  cd /opt
  source environment.sh
  ifort --version || exit 1
  icx --version || exit 1
  mpirun hostname || exit 1

  # Clean up

  apt remove -y $APT_NOT_REQUIRED


elif [ $ARCH = aarch64 ] ; then

  sudo update-alternatives --remove-all gcc || :
  sudo update-alternatives --remove-all g++ || :
  sudo update-alternatives --remove-all gfortran || :

  apt install -y build-essential gcc-12 g++-12 gfortran-12 libopenblas0 openmpi-bin libopenblas-dev libopenmpi-dev

  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11  10
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12  20

  sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11  10
  sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12  20

  sudo update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-11  10
  sudo update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-12  20

  sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
  sudo update-alternatives --set cc /usr/bin/gcc

  sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
  sudo update-alternatives --set c++ /usr/bin/g++


else 

  exit 1

fi

#!/bin/bash -e

cd /opt
source environment.sh
ARCH=$(uname -i)

APT_NOT_REQUIRED="wget make pkg-config autoconf libtool"
apt install -y $APT_NOT_REQUIRED

wget https://github.com/TREX-CoE/qmckl_dgemm/archive/refs/tags/v1.0.tar.gz
tar -zxvf v1.0.tar.gz
cd qmckl_dgemm-1.0
./autogen.sh

if [ $ARCH = x86_64 ] ; then

    export CFLAGS="-Ofast -g -qmkl=sequential -fma -march=core-avx2 -finline"
    export FCFLAGS="-Ofast -g -qmkl=sequential -ftz -fma -march=core-avx2 -ip"

    ./configure --prefix=/usr --enable-mkl CC=$CC FC=$FC

elif [ $ARCH = aarch64 ] ; then

    export CFLAGS="-mcpu=armv8-a -fno-signaling-nans -fno-trapping-math -freciprocal-math -fno-signed-zeros \
                   -fno-math-errno -ffinite-math-only -funroll-loops -O3 -ftree-vectorize -flto -fopenmp-simd"
    export FCFLAGS="-g -mcpu=armv8-a -O2 -fstack-arrays -ffast-math -flto -ftree-vectorize -fno-stack-protector"

    ./configure --prefix=/usr --enable-blas CC=$CC FC=$FC

else

  exit 1

fi

make
make check

cd ..
rm -rf qmckl_dgemm-1.0  v1.0.tar.gz

apt remove -y $APT_NOT_REQUIRED


#!/bin/bash -e

cd /opt
source environment.sh
ARCH=$(uname -i)

apt install -y wget make pkg-config autoconf libtool

which icx \
&& export CC=icx \
|| (apt install -y gcc libmkl-rt libopenblas-dev ; \
    cp /lib/x86_64-linux-gnu/libblas.so.3 /lib/x86_64-linux-gnu/libblas.so; \
    cp /lib/x86_64-linux-gnu/liblapack.so.3 /lib/x86_64-linux-gnu/liblapack.so)

which ifort \
&& export FC=ifort \
|| apt install -y gfortran libopenblas-dev

if [ $ARCH = x86_64 ] ; then
  if [ $CC = icx ] ; then
    export CFLAGS="-Ofast -g -qmkl=sequential -fma -march=core-avx2 -finline"
    export FCFLAGS="-Ofast -g -qmkl=sequential -ftz -fma -march=core-avx2 -ip"
  else
    export CFLAGS="-Ofast -g -march=core-avx2 -fopenmp-simd"
    export FCFLAGS="-Ofast -g -march=core-avx2 -fopenmp-simd"
  fi
elif [ $ARCH = aarch64 ] ; then
    export CFLAGS="-mcpu=armv8-a -fno-signaling-nans -fno-trapping-math -freciprocal-math -fno-signed-zeros -fno-math-errno -ffinite-math-only -funroll-loops -O3 -ftree-vectorize -flto -fopenmp-simd"
    export FCFLAGS="-g -mcpu=armv8-a -O2 -fstack-arrays -ffast-math -flto -ftree-vectorize -fno-stack-protector"
else
  exit 1
fi

wget https://github.com/TREX-CoE/qmckl_dgemm/archive/refs/tags/v1.0.tar.gz
tar -zxvf v1.0.tar.gz
cd qmckl_dgemm-1.0

./autogen.sh
if [ $FC = ifort ] ; then
        ./configure --prefix=/usr --enable-mkl CC=$CC FC=$FC
else
        ./configure --prefix=/usr --enable-blas CC=$CC FC=$FC
fi
make
make check

cd ..
rm -rf qmckl_dgemm-1.0  v1.0.tar.gz

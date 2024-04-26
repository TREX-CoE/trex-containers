#!/bin/bash -e

cd /opt
source environment.sh
ARCH=$(uname -i)

APT_NOT_REQUIRED="wget make pkg-config"
apt install -y $APT_NOT_REQUIRED

if [ $ARCH = x86_64 ] ; then

    export CFLAGS="-Ofast -g -qmkl=sequential -fma -march=core-avx2 -finline"
    export FCFLAGS="-Ofast -g -qmkl=sequential -ftz -fma -march=core-avx2 -ip"

elif [ $ARCH = aarch64 ] ; then

    export CFLAGS="-mcpu=armv8-a -fno-signaling-nans -fno-trapping-math -freciprocal-math -fno-signed-zeros \
                   -fno-math-errno -ffinite-math-only -funroll-loops -O3 -ftree-vectorize -flto -fopenmp-simd"
    export FCFLAGS="-g -mcpu=armv8-a -O2 -fstack-arrays -ffast-math -flto -ftree-vectorize -fno-stack-protector"

else

  exit 1

fi

wget https://github.com/TREX-CoE/qmckl/releases/download/v1.0.0/qmckl-1.0.0.tar.gz
tar -zxvf qmckl-1.0.0.tar.gz
cd qmckl-1.0.0

mkdir _build
cd _build
../configure --prefix=/usr --disable-python --disable-doc --enable-hpc --with-openmp
make -j 8
make -j 8 check
make install

cd /opt
rm -rf qmckl-1.0.0  qmckl-1.0.0.tar.gz

apt remove -y $APT_NOT_REQUIRED


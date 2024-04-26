#!/bin/bash -e

cd /opt
source environment.sh
ARCH=$(uname -i)

APT_NOT_REQUIRED="wget make pkg-config gcc gfortran"
apt install -y $APT_NOT_REQUIRED

if [ $ARCH = x86_64 ] ; then

    export CFLAGS="-Ofast -g -qmkl=sequential -fma -march=core-avx2 -finline"
    export FCFLAGS="-Ofast -g -qmkl=sequential -ftz -fma -march=core-avx2 -ip"

elif [ $ARCH = aarch64 ] ; then

    APT_REQUIRED="$APT_REQUIRED libopenblas0 openmpi-bin"
    APT_NOT_REQUIRED="$APT_NOT_REQUIRED libopenblas-serial-dev libopenmpi-dev"
    apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

    export CFLAGS="-mcpu=armv8-a -fno-signaling-nans -fno-trapping-math -freciprocal-math -fno-signed-zeros -fno-math-errno -ffinite-math-only -funroll-loops -O3 -ftree-vectorize -flto -fopenmp-simd"
    export FCFLAGS="-g -mcpu=armv8-a -O2 -fstack-arrays -ffast-math -flto -ftree-vectorize -fno-stack-protector"

else

  exit 1

fi

wget https://github.com/TREX-CoE/qmckl/releases/download/v1.0.0/qmckl-1.0.0.tar.gz
tar -zxvf qmckl-1.0.0.tar.gz
cd qmckl-1.0.0

mkdir _build_sequential
cd _build_sequential
../configure --prefix=/usr --disable-python --disable-doc --enable-hpc --without-openmp
make -j 8
make -j 8 check

# make install
/usr/bin/install -c src/.libs/libqmckl.so.0.0.0 /usr/lib/libqmckl-sequential.so.0.0.0
(cd /usr/lib \
 && { ln -s -f libqmckl-sequential.so.0.0.0 libqmckl-sequential.so.0 \
      || { rm -f libqmckl-sequential.so.0 \
           && ln -s libqmckl-sequential.so.0.0.0 libqmckl-sequential.so.0; }; })
(cd /usr/lib \
 && { ln -s -f libqmckl-sequential.so.0.0.0 libqmckl-sequential.so \
      || { rm -f libqmckl-sequential.so \
           && ln -s libqmckl-sequential.so.0.0.0 libqmckl-sequential.so; }; })
/usr/bin/install -c src/.libs/libqmckl.lai /usr/lib/libqmckl-sequential.la
sed -i "s/libqmckl/libqmckl-sequential/g" /usr/lib/libqmckl-sequential.la
/usr/bin/install -c src/.libs/libqmckl.a /usr/lib/libqmckl-sequential.a
chmod 644 /usr/lib/libqmckl-sequential.a
ranlib /usr/lib/libqmckl-sequential.a

cd ..

mkdir _build_parallel
cd _build_parallel
../configure --prefix=/usr --disable-python --disable-doc --enable-hpc --with-openmp
make -j 8
make -j 8 check
make install
cd ..

cd ..
rm -rf qmckl-1.0.0  qmckl-1.0.0.tar.gz

apt remove -y $APT_NOT_REQUIRED


#!/bin/bash -e

cd /opt
source environment.sh

# Install dependencies
# --------------------

APT_NOT_REQUIRED="git make"
apt install -y $APT_REQUIRED $APT_NOT_REQUIRED

git clone --depth=1 https://github.com/pernalk/GAMMCOR.git

cd GAMMCOR
mkdir OBJ

cd xcfun
make -j 8 -f Makefile
cd ..

if [ $ARCH = x86_64 ] ; then

cat << EOF > Makefile
FCC = ifort
FFLAGS = -assume byterecl -heap-arrays -mkl=parallel -qopenmp -I xcfun/fortran -O3 -g
LIBS = -L./xcfun/lib/ -lxcfun

include Makefile.common
EOF

elif [ $ARCH = aarch64 ] ; then

cd xcfun
make -j 8 -f Makefile.gcc
cd ..

cat << EOF > Makefile
MKL_ROOT = /opt/intel/mkl/

FCC = gfortran-12
FFLAGS = -O3 -g -I xcfun/fortran -fopenmp
LIBS = -L./xcfun/lib/ -lxcfun

include Makefile.common
EOF

fi

rm -f gammcor
make -j 8

# Test

ls gammcor || exit 1


# Clean up
rm -rf compile-* docs tests build lib

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required

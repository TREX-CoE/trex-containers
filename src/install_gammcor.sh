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

if [ $ARCH = x86_64 ] ; then

cd xcfun
sed -i "s/icc/icx/g" Makefile
sed -i "s/icpc/icpx/g" Makefile
rm -f src/*/*.o
make -f Makefile
cd ..


cat << EOF > Makefile
FCC = ifort -qmkl=parallel -qopenmp
FFLAGS = -assume byterecl -heap-arrays -I xcfun/fortran -O3 -g
LIBS = -L./xcfun/lib/ -lxcfun

include Makefile.common
EOF

elif [ $ARCH = aarch64 ] ; then

cd xcfun
sed -i "s/g++/g++-12 -fPIC -march=armv8-a/g" Makefile.gcc
sed -i "s/gcc/gcc-12 -fPIC -march=armv8-a/g" Makefile.gcc
sed -i "s/gfortran/gfortran-12 -fPIC -march=armv8-a/g" Makefile.gcc
rm -f src/*/*.o
make -f Makefile.gcc
cd ..


cat << EOF > Makefile
FCC = gfortran-12 -march=armv8-a 
FFLAGS = -O3 -g -I xcfun/fortran -fopenmp -fallow-argument-mismatch
LIBS = -L./xcfun/lib/ -lxcfun -lopenblas

include Makefile.common
EOF

fi

rm -f gammcor
make
mv gammcor /usr/bin/
cd ..
rm -rf /opt/GAMMCOR



# Clean up
rm -rf compile-* docs tests build lib

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required


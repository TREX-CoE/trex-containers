#!/bin/bash -e

cd /opt
source environment.sh

APT_REQUIRED="hdf5-tools hdf5-helpers libhdf5-cpp-103-1"
APT_NOT_REQUIRED="libhdf5-dev wget make"
apt install -y $APT_NOT_REQUIRED $APT_REQUIRED

wget https://github.com/TREX-CoE/trexio/releases/download/v2.4.2/trexio-2.4.2.tar.gz
tar -zxvf trexio-2.4.2.tar.gz
cd trexio-2.4.2
./configure --prefix=/usr
make -j 8
make -j 8 check
make install


# Clean up

cd /opt
rm -rf trexio-2.4.2 trexio-2.4.2.tar.gz
apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required

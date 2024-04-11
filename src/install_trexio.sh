#!/bin/bash -e

cd /opt
source environment.sh

apt install -y wget libhdf5-dev hdf5-tools make
[ -z $CC ] && apt install -y gcc
[ -z $FC ] && apt install -y gfortran


wget https://github.com/TREX-CoE/trexio/releases/download/v2.4.2/trexio-2.4.2.tar.gz
tar -zxvf trexio-2.4.2.tar.gz
cd trexio-2.4.2
./configure --prefix=/usr
make -j 8
make -j 8 check
make install
cd ..
rm -rf trexio-2.4.2 trexio-2.4.2.tar.gz


#!/bin/bash -e

cd /opt
source environment.sh

APT_REQUIRED="python3 hdf5-tools"
APT_NOT_REQUIRED="python3-pip git libhdf5-dev gcc python3-dev pkg-config"
apt install -y $APT_NOT_REQUIRED $APT_REQUIRED

ln -sf /usr/bin/python3 /usr/bin/python || :

pip --no-cache-dir install trexio

git clone --depth=1 https://github.com/TREX-CoE/trexio_tools.git
cd trexio_tools
pip  --no-cache-dir install .
cd ..

# Clean up

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required

rm -rf trexio_tools


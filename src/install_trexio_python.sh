#!/bin/bash -e

cd /opt
source environment.sh

apt install -y python3 python3-pip git
ln -s /usr/bin/python3 /usr/bin/python

pip install trexio

git clone --depth=1 https://github.com/TREX-CoE/trexio_tools.git
cd trexio_tools
pip install .
cd ..

rm -rf trexio_tools


#!/bin/bash -e

cd /opt
source environment.sh

apt install -y python3 python3-pip git
ln -sf /usr/bin/python3 /usr/bin/python

git clone --depth=1 https://github.com/kousuke-nakano/turbogenius.git
cd turbogenius
pip install .
cd ..

rm -rf turbogenius


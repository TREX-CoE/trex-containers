#!/bin/bash -e

cd /opt
source environment.sh

APT_REQUIRED="python3 git hdf5-tools"
APT_NOT_REQUIRED="python3-pip pkg-config gcc python3-dev libhdf5-dev"
apt install -y $APT_NOT_REQUIRED $APT_REQUIRED

ln -sf /usr/bin/python3 /usr/bin/python || :

git clone --depth=1 https://github.com/kousuke-nakano/turbogenius.git
cd turbogenius

pip --no-cache-dir install .
cd ..

rm -rf turbogenius

# Remove HGBS basis sets because they take too much disk space
rm -rf /usr/local/lib/*/dist-packages/basis_set_exchange/data/lehtola_hgbs


# Clean up

apt remove -y $APT_NOT_REQUIRED
echo $APT_REQUIRED >> /opt/install/apt_required

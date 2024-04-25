#!/bin/bash

TO_KEEP="$(cat /opt/install/apt_required)"
apt install -y $TO_KEEP  bash vim emacs-nox

#   apt remove -y wget make pkg-config pgpgpg git python3-pip cmake libhdf5-dev libopenmpi-dev

apt autoremove -y
apt purge -y --auto-remove
rm -rf /var/lib/apt/lists/*

echo source /opt/environment.sh >> /etc/bash.bashrc


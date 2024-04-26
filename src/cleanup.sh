#!/bin/bash

TO_KEEP="$(cat /opt/install/apt_required)"
apt install -y $TO_KEEP  bash vim emacs-nox

apt autoremove -y
apt purge -y --auto-remove
rm -rf /var/lib/apt/lists/*

echo source /opt/environment.sh >> /etc/bash.bashrc


# Setup
# -----

ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime
export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y bash


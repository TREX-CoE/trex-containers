# Setup
# -----

ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime
export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive

# Check if nc is installed
if [ $APT_CACHER = yes ] ; then
    echo "Acquire::http { Proxy \"http://localhost:3142\"; };" > /etc/apt/apt.conf.d/01proxy
fi

apt update
apt install -y bash


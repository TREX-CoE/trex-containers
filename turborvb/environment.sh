export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive
export ARCH=$(uname -i)

source /opt/intel/oneapi/setvars.sh || :

export FC=ifort
export CC=icx
export OMP_NUM_THREADS=1

export PATH=$PATH:/opt/turborvb/bin

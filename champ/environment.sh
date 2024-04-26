export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive
export ARCH=$(uname -i)

if [ $ARCH = x86_64 ] ; then
        source /opt/intel/oneapi/setvars.sh &>/dev/null || :
        export FC=ifort
        export CC=icx
else
        export FC=gfortran
        export CC=gcc
fi

export OMP_NUM_THREADS=1

export PATH=$PATH:/opt/champ/bin

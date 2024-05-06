export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive
export ARCH=$(uname -i)

if [ $ARCH = x86_64 ] ; then

        source /opt/intel/oneapi/setvars.sh &>/dev/null || :
        export FC=ifort
        export CC=icx

elif [ $ARCH = aarch64 ] ; then

        export FC=gfortran-12
        export CC=gcc-12

else

        exit 1

fi


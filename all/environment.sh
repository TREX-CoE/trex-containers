export LANG="C"
export LANGUAGE=$LANG
export LC_ALL=$LANG
export DEBIAN_FRONTEND=noninteractive
export ARCH=$(uname -i)

if [ $ARCH = x86_64 ] ; then

        source /opt/intel/oneapi/setvars.sh &>/dev/null || :
        export FC=ifort
        export CC=icx
	export INCLUDE=/opt/intel/oneapi/compiler/2024.1/opt/compiler/include/intel64/

elif [ $ARCH = aarch64 ] ; then

        export FC=gfortran-12
        export CC=gcc-12

else

        exit 1

fi

export PATH=$PATH:/opt/champ/bin
export PATH=$PATH:/opt/turborvb/bin

source /opt/qp2/quantum_package.rc || :

# QMC=Chem environment variables
export QMCCHEM_PATH="/opt/qmcchem2"
export PATH="${QMCCHEM_PATH}/bin:${PATH}"
export QMCCHEM_MPIRUN="mpirun"
export QMCCHEM_MPIRUN_FLAGS=""
#export QMCCHEM_NIC="ib0"


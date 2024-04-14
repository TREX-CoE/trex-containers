FROM debian:bookworm

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    wget \
    gnupg2 \
    lsb-release \
    git \
    bc \
    emacs \
    libhdf5-dev \
    libssl-dev \
    autoconf \
    automake \
    libtool \
    gfortran \
    xz-utils

RUN wget https://www.maqao.org/maqao_archive/maqao.x86_64.2.20.0.tar.xz && \
    mkdir -p /opt/maqao_2.20.0 && \
    tar xJvf maqao.x86_64.2.20.0.tar.xz -C /opt/maqao_2.20.0/

RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/163da6e4-56eb-4948-aba3-debcec61c064/l_BaseKit_p_2024.0.1.46_offline.sh && \
    chmod +x l_BaseKit_p_2024.0.1.46_offline.sh && \
    ./l_BaseKit_p_2024.0.1.46_offline.sh -a -s --eula accept --install-dir /opt/intel && \
    rm l_BaseKit_p_2024.0.1.46_offline.sh

RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/41df6814-ec4b-4698-a14d-421ee2b02aa7/l_fortran-compiler_p_2024.0.2.28_offline.sh && \
    chmod +x l_fortran-compiler_p_2024.0.2.28_offline.sh && \
    ./l_fortran-compiler_p_2024.0.2.28_offline.sh -a -s --eula accept --install-dir /opt/intel && \
    rm l_fortran-compiler_p_2024.0.2.28_offline.sh

# Install environment modules
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Paris \
    apt-get install -y environment-modules

# Install NVHPC toolkit
RUN wget https://developer.download.nvidia.com/hpc-sdk/23.11/nvhpc_2023_2311_Linux_x86_64_cuda_multi.tar.gz && \
    tar -xzf nvhpc_2023_2311_Linux_x86_64_cuda_multi.tar.gz && \
    cd nvhpc_2023_2311_Linux_x86_64_cuda_multi && \
    ./install --accept-eula --silent --installdir=/opt/nvidia/hpc_sdk && \
    cd .. && \
    rm -rf nvhpc_2023_2311_Linux_x86_64_cuda_multi.tar.gz nvhpc_2023_2311_Linux_x86_64_cuda_multi

# Add line to .bashrc for sourcing environment modules
RUN echo "source /usr/share/modules/init/bash" >> ~/.bashrc
RUN echo "module use /opt/nvidia/hpc_sdk/modulefiles" >> ~/.bashrc
RUN "/opt/intel/modulefiles-setup.sh"
RUN echo "module use /root/modulefiles" >> ~/.bashrc
#COPY intel /root/modulefiles/intel

# Copy directory with module files
COPY modules /usr/share/modules/modulefiles

RUN git clone https://github.com/Kitware/CMake.git && \
    cd CMake && \
    git checkout v3.28.1 && \
    ./bootstrap && \
    make -j 12 && \
    make install && \
    cd .. && \
    rm -rf CMake

RUN source /root/.bashrc && module load intel && git clone https://github.com/TREX-CoE/trexio.git && \
    cd trexio && \
    cmake -S . -B build -DCMAKE_C_COMPILER=gcc -DCMAKE_Fortran_COMPILER=gfortran && \
    cmake --build build -j 4 && \
    cmake --install build && \
    cd .. && \
    rm -rf trexio

RUN source /root/.bashrc && \
    module load intel && \
    git clone https://github.com/TREX-CoE/qmckl.git && \
    cd qmckl && \
    git checkout master && \
    ./autogen.sh && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/opt/qmckl_hpc --enable-hpc --with-icx --with-ifort CC=icx FC=ifort LDFLAGS="-Wl,-rpath=$MKLROOT/lib -Wl,-rpath=/opt/intel/compiler/2024.0/lib/" && \
    make -j 6 && \
    make install && \
    cd ../ && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/opt/qmckl_edu --with-icx --with-ifort CC=icx FC=ifort LDFLAGS="-Wl,-rpath=$MKLROOT/lib -Wl,-rpath=/opt/intel/compiler/2024.0/lib/" && \
    make -j 6 && \
    make install && \
    cd ../../ && \
    rm -rf qmckl

RUN git clone https://github.com/TREX-CoE/qmckl_gpu.git && \
    cd qmckl_gpu && \
    git checkout main && \
    source /root/.bashrc && module load intel && \
    ./autogen.sh && \
    for cc in 70 75 80 86 89 90; do \
        echo "Building for OMP cc${cc}" && \
        mkdir build && \
        cd build && \
        PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin:${PATH}" \
        LD_LIBRARY_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/lib:${LD_LIBRARY_PATH}" \
        LD_LIBRARY_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/cuda/12.3/targets/x86_64-linux/lib/:${LD_LIBRARY_PATH}" \
        ../configure --enable-omp --enable-fortran-interface CC=/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin/nvc FC=/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin/nvfortran CFLAGS="-gpu=cc${cc}" --prefix="/opt/qmckl_gpu_omp_${cc}" && \
        make -j 6 && \
        make install && \
        cp /opt/qmckl_gpu_omp_${cc}/include/qmckl_gpu_f.f90 /opt/qmckl_gpu_omp_${cc}/include/qmckl_gpu_f.F90 && \
        cd ../ && \
        rm -rf build && \
        echo "Building for ACC cc${cc}" && \
        mkdir build && \
        cd build && \
        PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin:${PATH}" \
        LD_LIBRARY_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/lib:${LD_LIBRARY_PATH}" \
        LD_LIBRARY_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/cuda/12.3/targets/x86_64-linux/lib/:${LD_LIBRARY_PATH}" \
        ../configure --enable-acc --enable-fortran-interface CC=/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin/nvc FC=/opt/nvidia/hpc_sdk/Linux_x86_64/23.11/compilers/bin/nvfortran CFLAGS="-gpu=cc${cc}" --prefix="/opt/qmckl_gpu_acc_${cc}" && \
        make -j 1 && \
        make install && \
        cp /opt/qmckl_gpu_acc_${cc}/include/qmckl_gpu_f.f90 /opt/qmckl_gpu_acc_${cc}/include/qmckl_gpu_f.F90 && \
        cd ../ && \
        rm -rf build; \
    done; \
    cd ../ && \
    rm -rf qmckl_gpu

# Set working directory
WORKDIR /app

# Set the entrypoint
ENTRYPOINT ["/bin/bash"]

ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1


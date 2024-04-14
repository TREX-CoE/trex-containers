FROM trex-base-tools:latest

RUN git clone https://github.com/sissaschool/turborvb.git && \
    cd turborvb && \
    source ~/.bashrc && \
    module load intel && \
    cmake -S . -B build-intel \
          -DCMAKE_C_COMPILER=icx \
          -DCMAKE_Fortran_COMPILER=ifort \
          -DCMAKE_INSTALL_PREFIX=/opt/turborvb && \
    cmake --build build-intel -j 8 && \
    cmake --build build-intel --target install

COPY turborvb /usr/share/modules/modulefiles/turborvb

         
     

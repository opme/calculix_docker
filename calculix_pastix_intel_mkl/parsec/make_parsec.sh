#!/bin/bash

if ! [[ -d build ]]; then
    mkdir build
fi
cd build

INSTALLPATH="/tmp/parsec_i8"

umask 022

# fixes
sed -i '/-1 == cpu/i return cpu;' parsec/bindthread.c

cmake \
    -DCMAKE_CXX_COMPILER=c++ \
    -DCMAKE_C_COMPILER=cc \
    -DCMAKE_Fortran_COMPILER=ifort \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${INSTALLPATH} \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_DIR=/usr/local/cuda \
    -DCUDA_USE_STATIC_CUDA_RUNTIME=ON \
    -DCMAKE_CUDA_HOST_COMPILER=cc \
    -DPARSEC_GPU_WITH_CUDA=ON \
    -DHWLOC_DIR=/tmp/hwloc_i8 \
    ..

make -j8
make install

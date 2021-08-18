#!/bin/bash
if ! [[ -d build ]]; then
    mkdir build
fi
cd build

INSTALLPATH="/tmp/pastix"
CUDADIR="/usr/local/cuda"
PARSECDIR="/tmp/parsec_i8"
SCOTCHDIR="/tmp/scotch_6.0.8"
HWLOCDIR="/tmp/hwloc_i8"
export C_INCLUDE_PATH=${CUDADIR}/include:${C_INCLUDE_PATH}
export LIBRARY_PATH=${CUDADIR}/lib64:$LIBRARY_PATH
export LD_LIBRARY_PATH=${CUDADIR}/lib64:$LD_LIBRARY_PATH

cmake \
	-DCUDA_TOOLKIT_ROOT_DIR=${CUDADIR} \
	-DCMAKE_INSTALL_PREFIX=${INSTALLPATH} \
	-DCMAKE_BUILD_TYPE=Release \
	-DPASTIX_WITH_PARSEC=ON \
	-DPARSEC_DIR=${PARSECDIR} \
	-DSCOTCH_DIR=${SCOTCHDIR} \
	-DHWLOC_DIR=${HWLOCDIR} \
	-DPASTIX_WITH_CUDA=ON \
	-DCUDA_DIR=${CUDADIR} \
	-DPASTIX_ORDERING_SCOTCH=ON \
	-DCMAKE_C_COMPILER=cc \
	-DCMAKE_CXX_COMPILER=c++ \
	-DCMAKE_Fortran_COMPILER=ifort \
	-DCMAKE_C_FLAGS="-fopenmp -I/usr/local/cuda/include" \
    ..

make
make install

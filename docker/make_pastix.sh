#!/bin/bash
if ! [[ -d build ]]; then
    mkdir build
fi
cd build


cmake   \
        -DBLAS_DIR=/tmp/OpenBLAS_i8 \
	-DHWLOC_DIR=/tmp/hwloc_i8 \
	-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.2 \
	-DCMAKE_INSTALL_PREFIX=/tmp/pastix_i8 \
	-DCMAKE_BUILD_TYPE=Release \
	-DPASTIX_WITH_PARSEC=ON \
	-DPARSEC_DIR=/tmp/parsec_i8 \
	-DSCOTCH_DIR=/tmp/scotch_i8 \
	-DPASTIX_WITH_CUDA=ON \
	-DCUDA_DIR=/usr/local/cuda-10.2 \
	-DPASTIX_ORDERING_SCOTCH=ON \
	-DCMAKE_C_COMPILER=cc \
	-DCMAKE_CXX_COMPILER=c++ \
	-DCMAKE_Fortran_COMPILER=ifort \
	-DCMAKE_C_FLAGS="-fopenmp" \
        ..

make -j8
make install

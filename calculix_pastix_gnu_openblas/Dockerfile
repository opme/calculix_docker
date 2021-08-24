# aerospace software
# author: Michael Shamberger

# build spooles
FROM ubuntu:20.04 as spooles
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc build-essential
WORKDIR /tmp
RUN wget http://www.netlib.org/linalg/spooles/spooles.2.2.tgz && \
    mkdir spooles.2.2 && \
    cd spooles.2.2 && \
    tar -xvzf ../spooles.2.2.tgz
COPY spooles/Make.inc /tmp/spooles.2.2/Make.inc 
RUN cd spooles.2.2 && \
    make lib

# build arpack
FROM ubuntu:20.04 as arpack
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc gfortran build-essential
WORKDIR /tmp
RUN wget https://www.caam.rice.edu/software/ARPACK/SRC/arpack96.tar.gz && \
    wget https://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz && \
    tar -xvzf arpack96.tar.gz && \
    tar -xvzf patch.tar.gz
COPY arpack/ARmake.inc /tmp/ARPACK
COPY arpack/second.f /tmp/ARPACK/UTIL
RUN cd ARPACK && \
    make lib

# build pastix
FROM ubuntu:20.04 as pastix
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git flex bison libz-dev software-properties-common gcc gfortran build-essential cmake python2-minimal
# install nvidia toolkit
RUN apt-get install -y freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
RUN add-apt-repository ppa:graphics-drivers/ppa
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | tee /etc/apt/sources.list.d/cuda.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-overwrite" install cuda-11-4 cuda-drivers

WORKDIR /tmp
# BLAS (e.g. OpenBLAS)
RUN git clone https://github.com/xianyi/OpenBLAS.git OpenBLAS_i8 && \
    cd OpenBLAS_i8 && \
    make && \
    make install
# hwloc-2.1.0
RUN wget https://download.open-mpi.org/release/hwloc/v2.1/hwloc-2.1.0.tar.gz && \
    tar -xvzf hwloc-2.1.0.tar.gz
COPY hwloc/make_hwloc.sh /tmp/hwloc-2.1.0
RUN  cd hwloc-2.1.0 && \
    ./make_hwloc.sh
# parsec
RUN git clone -b pastix-6.0.2 --single-branch https://bitbucket.org/mfaverge/parsec.git parsec_i8
COPY parsec/make_parsec.sh /tmp/parsec_i8
RUN mkdir -p /tmp/parsec_i8/build/tools/profiling/python && \
    touch parsec_i8/build/tools/profiling/python/pbt2ptt.so
RUN cd parsec_i8 && \
    ./make_parsec.sh
# scotch
RUN wget https://gforge.inria.fr/frs/download.php/file/38114/scotch_6.0.8.tar.gz && \
    tar -xvzf scotch_6.0.8.tar.gz
COPY scotch/make_scotch.sh /tmp/scotch_6.0.8
RUN cd scotch_6.0.8 && \
    ./make_scotch.sh
# PaStiX4CalculiX
RUN git clone https://github.com/Dhondtguido/PaStiX4CalculiX pastix_i8
COPY pastix/make_pastix.sh /tmp/pastix_i8
RUN cd pastix_i8 && \
    ./make_pastix.sh

# build calculix
FROM ubuntu:20.04 as calculix
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc gfortran build-essential zlib1g-dev
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
WORKDIR /tmp
COPY --from=spooles /tmp/spooles.2.2 /tmp/spooles.2.2
COPY --from=arpack /tmp/ARPACK /tmp/ARPACK_i8
COPY --from=pastix /tmp/hwloc_i8/lib /tmp/hwloc_i8/lib
COPY --from=pastix /opt/OpenBLAS/lib /opt/OpenBLAS/lib
COPY --from=pastix /tmp/scotch_6.0.8/lib /tmp/scotch_i8/lib
COPY --from=pastix /tmp/parsec_i8/lib /tmp/parsec_i8/lib
COPY --from=pastix /tmp/pastix_i8/lib /tmp/pastix_i8/lib
COPY --from=pastix /tmp/pastix_i8/include /tmp/pastix_i8/include
COPY --from=pastix /usr/local/cuda/lib64 /usr/local/cuda/lib64
COPY --from=pastix /usr/local/cuda/targets/x86_64-linux/lib /usr/local/cuda/targets/x86_64-linux/lib
RUN wget http://www.dhondt.de/ccx_2.17.src.tar.bz2 && \
    bunzip2 ccx_2.17.src.tar.bz2 && \
    tar xvf ccx_2.17.src.tar
COPY calculix/Makefile_i8 /tmp/CalculiX/ccx_2.17/src
RUN cd CalculiX/ccx_2.17/src && \
    make -f Makefile_i8


#
# base image
#
FROM nvidia/cuda:11.4.1-runtime-ubuntu18.04
CMD nvidia-smi
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/lib:/usr/local/hwloc/lib
RUN apt-get update
RUN apt-get install -y gcc libgfortran5
COPY --from=calculix /tmp/CalculiX/ccx_2.17/src/ccx_2.17_i8 /usr/local/bin/ccx
COPY --from=calculix /tmp/parsec_i8/lib/libparsec.so.2 /usr/local/lib
COPY --from=calculix /tmp/hwloc_i8/lib /usr/local/hwloc/lib
WORKDIR /

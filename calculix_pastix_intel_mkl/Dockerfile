# aerospace software
# author: Michael Shamberger

# build spooles
FROM intel/oneapi-hpckit:latest as spooles
RUN apt-get update
RUN apt-get install -y wget git
WORKDIR /tmp
RUN wget http://www.netlib.org/linalg/spooles/spooles.2.2.tgz && \
    mkdir spooles.2.2 && \
    cd spooles.2.2 && \
    tar -xvzf ../spooles.2.2.tgz
COPY spooles/Make.inc /tmp/spooles.2.2/Make.inc 
RUN cd spooles.2.2 && \
    make lib

# build arpack
FROM intel/oneapi-hpckit:latest as arpack
RUN apt-get update
RUN apt-get install -y wget git
WORKDIR /tmp
RUN wget https://www.caam.rice.edu/software/ARPACK/SRC/arpack96.tar.gz && \
    wget https://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz && \
    tar -xvzf arpack96.tar.gz && \
    tar -xvzf patch.tar.gz
COPY arpack/ARmake.inc /tmp/ARPACK
RUN cd ARPACK && \
    make lib

# build pastix
FROM intel/oneapi-hpckit:latest as pastix
RUN apt-get update
RUN apt-get install -y wget git flex bison libz-dev software-properties-common
WORKDIR /tmp

#RUN apt-get install -y nvidia-cuda-toolkit
RUN apt-get install -y freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
RUN add-apt-repository ppa:graphics-drivers/ppa
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | tee /etc/apt/sources.list.d/cuda.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-overwrite" install cuda-11-4 cuda-drivers

WORKDIR /tmp

# get CalculiX
RUN wget http://www.dhondt.de/ccx_2.17.src.tar.bz2 && \
    bunzip2 ccx_2.17.src.tar.bz2 && \
    tar xvf ccx_2.17.src.tar
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
COPY pastix/LibrariesAbsolutePath.cmake /tmp/pastix_i8/cmake_modules/morse_cmake/modules/find/LibrariesAbsolutePath.cmake
#RUN cd pastix_i8 && \
#    ./make_pastix.sh


#
# base image
#
FROM continuumio/anaconda3
EXPOSE 8888

RUN apt-get update
RUN apt-get install -y unzip libcminpack-dev ffmpeg libsm6 libxext6
COPY --from=spooles /tmp/spooles.2.2.tgz /
COPY --from=arpack  /tmp/patch.tar.gz /
COPY --from=pastix  /tmp/ccx_2.17.src.tar /

# add command
WORKDIR /
CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

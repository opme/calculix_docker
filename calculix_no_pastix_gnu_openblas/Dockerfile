# aerospace software
# author: Michael Shamberger

# build spooles
FROM ubuntu:20.04 as spooles
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc gfortran build-essential
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
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc gfortran build-essential cmake
WORKDIR /tmp
RUN git clone https://github.com/xianyi/OpenBLAS.git OpenBLAS_i8 && \
    cd OpenBLAS_i8 && \
    make && \
    make install
RUN wget https://www.caam.rice.edu/software/ARPACK/SRC/arpack96.tar.gz && \
    wget https://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz && \
    tar -xvzf arpack96.tar.gz && \
    tar -xvzf patch.tar.gz
COPY arpack/ARmake.inc /tmp/ARPACK
COPY arpack/second.f /tmp/ARPACK/UTIL
RUN cd ARPACK && \
    make lib

# build calculix
FROM ubuntu:20.04 as calculix
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget git gcc gfortran build-essential
WORKDIR /tmp
COPY --from=spooles /tmp/spooles.2.2 /tmp/spooles.2.2
COPY --from=arpack /tmp/ARPACK /tmp/ARPACK
RUN wget http://www.dhondt.de/ccx_2.17.src.tar.bz2 && \
    bunzip2 ccx_2.17.src.tar.bz2 && \
    tar xvf ccx_2.17.src.tar
COPY calculix/Makefile /tmp/CalculiX/ccx_2.17/src
RUN cd CalculiX/ccx_2.17/src && \
    make

#
# base image
#
FROM continuumio/anaconda3
EXPOSE 8888

RUN apt-get update
RUN apt-get install -y wget zip
COPY --from=calculix /tmp/CalculiX/ccx_2.17/src/ccx_2.17 /usr/local/bin

# add command
WORKDIR /
CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

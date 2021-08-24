# aerospace software
# author: Michael Shamberger

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
COPY arpack/second.f /tmp/ARPACK/UTIL
RUN cd ARPACK && \
    make lib

# build calculix
FROM intel/oneapi-hpckit:latest as calculix
RUN apt-get update
RUN apt-get install -y wget git
WORKDIR /tmp
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
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y wget zip
COPY --from=calculix /tmp/CalculiX/ccx_2.17/src/ccx_2.17_MT /usr/local/bin/ccx
WORKDIR /

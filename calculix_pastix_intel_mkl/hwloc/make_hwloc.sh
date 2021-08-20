#!/bin/bash

umask 022
mkdir -p /tmp/hwloc_i8

./configure --prefix=/tmp/hwloc_i8 --enable-static=yes CC=cc CXX=c++
make -j8
make install

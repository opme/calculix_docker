#!/bin/bash

umask 022
./configure --prefix=/tmp/hwloc_i8 CC=cc CXX=c++
make -j8
make install

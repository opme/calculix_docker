#!/bin/bash

umask 022
mkdir -p /tmp/hwloc_i8

./configure --prefix=/tmp/hwloc_i8 --enable-static=yes CC=gcc CXX=g++
make -j8
make install

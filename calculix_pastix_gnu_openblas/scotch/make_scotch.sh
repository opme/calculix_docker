#!/bin/bash

umask 022
cd src
cp Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc
sed -i '/CFLAGS/ s/$/ -DINTSIZE64/' Makefile.inc

make -j8 scotch
make -j8 esmumps
# install
make prefix=/tmp/scotch_6.0.8 install
ls /tmp/scotch_6.0.8/lib

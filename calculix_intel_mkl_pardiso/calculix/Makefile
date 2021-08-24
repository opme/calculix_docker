
CFLAGS = -w -O3 -fopenmp -DARCH="Linux" -DMATRIXSTORAGE -DUSE_MT=1 -DARPACK -DPARDISO_MPI -DMKL_ILP64 -DLONGLONG -I${MKLROOT}/include
FFLAGS = -w -O3 -fopenmp -i8 -I${MKLROOT}/include

CC=mpicc
FC=mpiifort

.c.o :
	$(CC) $(CFLAGS) -c $<
.f.o :
	$(FC) $(FFLAGS) -c $<

include Makefile.inc

SCCXMAIN = ccx_2.17.c

OCCXF = $(SCCXF:.f=.o)
OCCXC = $(SCCXC:.c=.o)
OCCXMAIN = $(SCCXMAIN:.c=.o)

LIBS = /tmp/ARPACK/libarpack_INTEL.a

ccx_2.17_MT: $(OCCXMAIN) ccx_2.17_MT.a  $(LIBS)
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.17.c; $(FC) $(FFLAGS) -static-intel -nofor-main -o $@ $(OCCXMAIN) ccx_2.17_MT.a $(LIBS)  -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a ${MKLROOT}/lib/intel64/libmkl_blacs_intelmpi_ilp64.a -Wl,--end-group -lpthread -lm -ldl

ccx_2.17_MT.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?

#!/bin/bash
echo $0
echo $1
#echo 'g++ -m32 -I/usr/include/gsl -I/usr/local/cuda/include -I/home/nabhoth/NVIDIA_CUDA_SDK/C/common/inc -L/usr/local/lib -lgsl -lgslcblas lif.cc'

g++ -m64 -I/usr/include/gsl -I/usr/local/include/gsl -L/usr/lib -L/usr/local/lib -lgsl -lgslcblas -g -O0 -fno-inline -o cr cr.cc
#g++ -m32 -I/usr/local/include/gsl -L/usr/lib -L/usr/local/lib -lgsl -lgslcblas -o cr cr.cc
./cr $1

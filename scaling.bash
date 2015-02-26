#!/bin/bash

#PBS -N mklScaling
#PBS -j oe
#PBS -q shared_large
#PBS -l nodes=1:ppn=16
#PBS -l walltime=5:00:00
#PBS -M defusco@pitt.edu
#PBS -m abe

cd $PBS_O_WORKDIR

module purge
module load intel/2011.12
module load mkl/2011.12/icc-mt

for ((n=512;n<=16384;n=n*2))
do
  for ((i=1;i<=$PBS_NUM_PPN;i++))
  do
    export MKL_NUM_THREADS=$i
    for ((tries=1;tries<=11;tries++))
    do
      build/big 1 $n
    done | grep "block " | tail -n 10 | \
      awk -v i=$i -v n=$n '{sum+=$3} END{printf "%6d %6d %12.8f\n",i,n,sum/NR}' 
  done
  echo
done

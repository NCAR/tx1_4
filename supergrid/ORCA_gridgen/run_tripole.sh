#!/bin/bash -l
#PBS -N tripole
#PBS -A NCGD0011
#PBS -l select=1:ncpus=24:ompthreads=24:mpiprocs=1:mem=100GB
#PBS -l walltime=24:00:00
#PBS -q casper
#PBS -m abe
#PBS -M fredc@ucar.edu

./tripole.exe

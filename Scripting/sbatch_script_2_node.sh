#!/bin/sh

#SBATCH -n 2
#SBATCH -N 2
#SBATCH -p software
#SBATCH -t 00:01:00

#echo " $actualVersion/$compiler: mpirun run_singularity.sh ubuntu.$actualVersion.img ring" >> results.txt

if mpirun run_singularity.sh ubuntu.$actualVersion.img ring; then
        echo "$versionFT2 $actualVersion $compiler OK!! (2 nodes)" >> results/$versionFT2-$actualVersion-$compiler
fi

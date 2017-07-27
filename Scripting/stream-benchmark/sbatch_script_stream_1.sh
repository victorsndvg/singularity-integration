#!/bin/bash
#SBATCH -n 48
#SBATCH -N 2
#SBATCH --ntasks-per-node=24
#SBATCH -p thinnodes
#SBATCH -t 12:00:00

if srun singularity exec \
-B /lib64:/host/lib64 \
-B /usr/lib64:/host/usr/lib64 \
-B $HOST_LIBS/lib64:/host/filtered/lib64 \
-B $HOST_LIBS/usr/lib64:/host/filtered/usr/lib64 \
-B /opt/cesga/openmpi/$OPEN_MPI_VERSION/$COMPILER/$COMPILER_VERSION/lib:/.singularity.d/libs \
-B $HOST_LIBS/mpi:/host/mpi \
-B /opt/cesga:/opt/cesga \
-B /usr/lib64/slurm:/usr/lib64/slurm \
-B /etc/slurm:/etc/slurm \
-B /var/run/munge:/run/munge \
-B /etc/libibverbs.d:/etc/libibverbs.d \
-B /mnt:/mnt \
ubuntu.$CONTAINER_OPEN_MPI_VERSION.stream.img bash -c "export LD_LIBRARY_PATH=$LIBS_PATH:\$LD_LIBRARY_PATH; stream_mpi"; then
        echo "FT2: $OPEN_MPI_VERSION | Container: $CONTAINER_OPEN_MPI_VERSION | OK!!" >> results.txt
        echo "FT2: $OPEN_MPI_VERSION | Container: $CONTAINER_OPEN_MPI_VERSION | OK!!"
fi

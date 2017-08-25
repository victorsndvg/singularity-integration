#!/bin/sh

#SBATCH -n 2
#SBATCH -N 2
#SBATCH -p thinnodes
#SBATCH -t 00:10:30

if srun singularity exec \
-B /lib64:/host/lib64 \
-B /usr/lib64:/host/usr/lib64 \
-B $HOST_LIBS/lib64:/host/filtered/lib64 \
-B $HOST_LIBS/usr/lib64:/host/filtered/usr/lib64 \
-B /opt/cesga/easybuild/software/OpenMPI/$OPEN_MPI_VERSION-$COMPILER_EASYBUILD-$COMPILER_VERSION_EASYBUILD/lib:/.singularity.d/libs \
-B $HOST_LIBS/mpi:/host/mpi \
-B /opt/cesga:/opt/cesga \
-B /usr/lib64/slurm:/usr/lib64/slurm \
-B /etc/slurm:/etc/slurm \
-B /var/run/munge:/run/munge \
-B /etc/libibverbs.d:/etc/libibverbs.d \
-B /mnt:/mnt \
ubuntu."$CONTAINER_OPEN_MPI_VERSION".img bash -c "export LD_LIBRARY_PATH=$LIBS_PATH:\$LD_LIBRARY_PATH; program-name"

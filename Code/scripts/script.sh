#!/bin/bash

#/*---- DEBUGGING MODE ----*/
DEBUG=false
if [ $# -eq 1 ]; then
   for arg in "$@"; do
      if [ "$arg" == "--debug" ]; then
         DEBUG=true
      fi
   done
fi


#/*---- FUNCTIONS ----*/
printfCenter() {
   termwidth="$(tput cols)"
   padding="$(printf '%0.1s' ={1..500})"
   printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}


#/*---- MAIN ----*/
export HOST_LIBS=/path/to/host-libs/
CONTAINER_OPEN_MPI_VERSIONS=( "1.10.2" "2.0.0" "2.0.1" "2.0.2" "2.1.1" )

# NO EASYBUILD VERSION ( 1.10.2 | 2.0.0 | 2.0.1 )
OPEN_MPI_VERSIONS=( "1.10.2" "2.0.0" "2.0.1" )
COMPILER=gcc; export COMPILER=$COMPILER
for OPEN_MPI_VERSION in "${OPEN_MPI_VERSIONS[@]}"; do
   export OPEN_MPI_VERSION=$OPEN_MPI_VERSION
   if [ "$OPEN_MPI_VERSION" = "1.10.2" ]; then
      export LIBS_PATH=/host/filtered/lib64:/host/filtered/usr/lib64:/host/mpi/lib/ompi_1.X
   else
      export LIBS_PATH=/host/filtered/lib64:/host/filtered/usr/lib64:/host/mpi/lib/ompi_2.X
   fi
   if [ "$OPEN_MPI_VERSION" = "2.0.1" ]; then
      COMPILER_VERSION=6.3.0
   else
      COMPILER_VERSION=6.1.0
   fi
   export COMPILER_VERSION=$COMPILER_VERSION
   module load $COMPILER/$COMPILER_VERSION openmpi/$OPEN_MPI_VERSION singularity
   for CONTAINER_OPEN_MPI_VERSION in "${CONTAINER_OPEN_MPI_VERSIONS[@]}"; do
      export CONTAINER_OPEN_MPI_VERSION=$CONTAINER_OPEN_MPI_VERSION
      printfCenter "START! FT2: $OPEN_MPI_VERSION | Container: $CONTAINER_OPEN_MPI_VERSION"
      if [ "$DEBUG" == "true" ]; then
         echo COMPILER=$COMPILER/$COMPILER_VERSION
         echo LIBS_PATH=$LIBS_PATH
      else
         sbatch sbatch_script_1.sh
      fi
   done
done


# EASYBUILD VERSION ( 2.0.2 | 2.1.1 )
OPEN_MPI_VERSIONS=( "2.0.2" "2.1.1" )
export LIBS_PATH=/host/filtered/lib64:/host/filtered/usr/lib64:/host/mpi/lib/ompi_2.X
for OPEN_MPI_VERSION in "${OPEN_MPI_VERSIONS[@]}"; do
   export OPEN_MPI_VERSION=$OPEN_MPI_VERSION
   if [ "$OPEN_MPI_VERSION" = "2.0.2" ]; then
      COMPILER=gcc
      COMPILER_VERSION=6.3.0
      COMPILER_EASYBUILD=GCC
      COMPILER_VERSION_EASYBUILD=6.3.0-2.27
   else
      COMPILER=intel
      COMPILER_VERSION=2016
      COMPILER_EASYBUILD=iccifort
      COMPILER_VERSION_EASYBUILD=2016eb
   fi
   export COMPILER_EASYBUILD=$COMPILER_EASYBUILD
   export COMPILER_VERSION_EASYBUILD=$COMPILER_VERSION_EASYBUILD
   module load $COMPILER/$COMPILER_VERSION openmpi/$OPEN_MPI_VERSION singularity
   for CONTAINER_OPEN_MPI_VERSION in "${CONTAINER_OPEN_MPI_VERSIONS[@]}"; do
      export CONTAINER_OPEN_MPI_VERSION=$CONTAINER_OPEN_MPI_VERSION
      printfCenter "START! FT2: $OPEN_MPI_VERSION | Container: $CONTAINER_OPEN_MPI_VERSION"
      if [ "$DEBUG" == "true" ]; then
         echo COMPILER=$COMPILER/$COMPILER_VERSION
         echo LIBS_PATH=$LIBS_PATH
      else
         sbatch sbatch_script_2.sh
      fi
   done
done

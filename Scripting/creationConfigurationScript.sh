#!/bin/bash

#/*---- GLOBAL VARIABLES ----*/
version=( "1.10.2" "2.0.0" "2.0.1" "2.0.2" "2.1.1" ) #Include as many OpenMPI versions as needed
os="ubuntu" #The OS will be downloaded from DockerHub. This script will work only with Debian derivates.

#/*---- FUNCTIONS ----*/
printfCenter() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
  printf "\n\n"
}

#/*---- MAIN ----*/
if [[ $EUID -ne 0 ]]; then
	echo "Sorry, you must exec this script with sudo option."
	exit 1
else
	for i in "${version[@]}" ; do

		definition=$os.$i.def
		image=$os.$i.img
		file=openmpi-$i.tar.gz

		printfCenter "Creation and configuration of $image"

		#Creation of definition files
		echo "BootStrap: docker
From: $os
IncludeCmd: yes

%post
	# Get the system ready
	sed -i 's/main/main restricted universe/g' /etc/apt/sources.list
	apt-get update
	apt-get install -y bash git wget build-essential gcc time libc6-dev libgcc-5-dev python
	##Install OpenMPI
	cd /tmp
	wget 'https://www.open-mpi.org/software/ompi/v${i::-2}/downloads/$file' -O $file
	tar -xzf $file
	mkdir -p /tmp/openmpi-$i/build
	cd /tmp/openmpi-$i/build
	../configure --prefix=/usr
	make clean
	make all install
	# Install ring
	cd /tmp
	wget https://raw.githubusercontent.com/open-mpi/ompi/master/examples/ring_c.c
	mpicc ring_c.c -o /usr/bin/ring
	# Try everything is ok
	ring
	# Create some folders
	mkdir -p /scratch /tmp /home /opt/cesga /mnt
	" > $definition

		#Creation of singularity images
		singularity create $image #The images will have the default value (769MB). It should be enougth.

		#Bootstrap of all (As many Ubuntu as version defined on the array, each one with a different version of OpenMPI)
		sudo singularity bootstrap $image $definition

		printfCenter "End of $image"
	done
fi

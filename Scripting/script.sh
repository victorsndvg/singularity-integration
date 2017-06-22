#!/bin/bash

#/*---- GLOBAL VARIABLES ----*/
compiler1_10_2=( "gcc/5.3.0" "gcc/6.1.0" "intel/2016" )
compiler2_0_0=( "gcc/6.1.0" )
compiler2_0_1=( "gcc/6.3.0" "intel/2016" )
compiler2_0_2=( "gcc/6.3.0" )
compiler2_1_1=( "intel/2016" "intel/2017" )

version=( "1.10.2" "2.0.0" "2.0.1" "2.0.2" "2.1.1" )
versionSimple=( "1.10.2" "2.0.0" )

#/*---- FUNCTIONS ----*/
internLoopDynamicName() {
    looparray="$1[@]"
    for compiler in "${!looparray}"; do
    	module load $compiler openmpi/$versionFT2
		export compiler=$compiler
		for actualVersion in "${version[@]}" ; do
			export actualVersion=$actualVersion
			echo "Running: sbatch sbatch_script_1_node.sh ( $versionFT2 / $actualVersion / $compiler )"
			sbatch sbatch_script_1_node.sh
			echo "Running: sbatch sbatch_script_2_node.sh ( $versionFT2 / $actualVersion / $compiler )"
			sbatch sbatch_script_2_node.sh
		done
    done
}

#/*---- MAIN ----*/
mkdir results
module load singularity
for versionFT2 in "${versionSimple[@]}" ; do
	export versionFT2=$versionFT2
	versionAux=compiler${versionFT2//./_} #Change all "." to "_"
	internLoopDynamicName $versionAux
done

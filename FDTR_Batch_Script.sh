#!/bin/bash
#SBATCH --account=p32089
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1GB
#SBATCH --time=4:00:00

script_name="fdtr_connected_theta_75_freq_10e6_x0_15.i"

moose_exec.sh ../purple-opt -i ${script_name}

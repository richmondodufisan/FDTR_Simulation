#!/bin/bash
#SBATCH --account=p32089
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem=1GB
#SBATCH --time=4:00:00

script_name="FDTR_input_theta_75_freq_1e6_x0_4.i"

#moose_exec.sh ../purple-opt -i ${script_name} --mesh-only
moose_exec.sh ../purple-opt -i ${script_name}

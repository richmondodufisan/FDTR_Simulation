#!/bin/bash
#SBATCH --account=p32089  ## YOUR ACCOUNT pXXXX or bXXXX
#SBATCH --partition=short  ### PARTITION (buyin, short, normal, etc)
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=25 ## how many cpus or processors do you need on each computer
#SBATCH --time=4:00:00 ## how long does this need to run (remember different partitions have restrictions on this param)
#SBATCH --mem-per-cpu=800M ## how much RAM do you need per CPU (this effects your FairShare score so be careful to not ask for more than you need))
#SBATCH --job-name=-1510  ## When you run squeue -u NETID this is how you can identify the job

script_name="FDTR_input_theta_0_freq_1e6_x0_-15_v1.i"

# Generate a random sleep duration between 1 and 1000 seconds
sleep_duration=$((1 + RANDOM % 100))

module purge
module use /software/spack_v20d1/spack/share/spack/modules/linux-rhel7-x86_64/
module load singularity
module load mpi/mpich-4.0.2-gcc-10.4.0

# Sleep for the randomly generated duration
sleep $sleep_duration

mpiexec -np ${SLURM_NTASKS} singularity exec -B /projects:/projects -B /projects/p32089/singularity/moose/moose:/opt/moose /projects/p32089/singularity/moose_latest.sif ../purple-opt -i ${script_name}



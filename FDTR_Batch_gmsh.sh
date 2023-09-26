#!/bin/bash
#SBATCH --account=p32089
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=8GB
#SBATCH --time=0:05:00

og_mesh_script="FDTR_mesh"
og_mesh_ext=".geo"
new_mesh="FDTR_mesh_theta_0_x0_-4.msh"

gmsh "${og_mesh_script}${og_mesh_ext}" -3 -o "$new_mesh" -save_all

#!/bin/bash
#SBATCH --account=p32089
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1GB
#SBATCH --time=0:10:00

og_mesh_script="FDTR_mesh"
og_mesh_ext=".geo"
new_mesh="FDTR_mesh_theta_75_x0_4.msh"

gmsh "${og_mesh_script}${og_mesh_ext}" -3 -o "$new_mesh" -save_all >> gmsh_output.txt 2>&1

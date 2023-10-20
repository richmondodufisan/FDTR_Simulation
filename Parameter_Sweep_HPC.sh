#!/bin/bash

#Original file name
og_filename="FDTR_input"
extension=".i"

og_mesh_script="FDTR_mesh"
og_mesh_ext=".py"

final_period=2.0

# Define the range of values you want to loop over

#x0_vals_num=("-15")

#freq_vals_num=("4e6")

#theta_vals_num=("0")

x0_vals_num=("-15" "-10" "-9" "-8" "-7" "-6" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "15")

freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

theta_vals_num=("0" "75")


# Loop over values
for x0_val_num in "${x0_vals_num[@]}"; do

		# Replace the x0_val value in the mesh script
		sed -i "s/\(xcen\s*=\s*\)[0-9.eE+-]\+/\1$x0_val_num/g" "${og_mesh_script}${og_mesh_ext}"
		
		# Replace the theta_val value in the mesh script
		# sed -i "0,/theta\s*=\s*[0-9.eE+-]\+/{s//theta = $theta_val_num/}" "${og_mesh_script}${og_mesh_ext}"
		
		# Replace the mesh name in the mesh script
		new_mesh_name="${og_mesh_script}_x0_${x0_val_num}.msh"
		sed -i "0,/newMeshName = [^ ]*/s/newMeshName = [^ ]*/newMeshName = \"$new_mesh_name\"/" "${og_mesh_script}${og_mesh_ext}"	
		
		#echo "$new_mesh_name"
		
		# Make new 3D mesh
		python3 FDTR_mesh.py >> gmsh_output.txt &
		wait
		
		# Submit Job
		#sbatch --wait FDTR_Batch_gmsh.sh
		
		echo "Mesh Generated, x0 = ${x0_val_num}"
		
	for theta_val_num in "${theta_vals_num[@]}"; do
		for freq_val_num in "${freq_vals_num[@]}"; do
			# Create a new filename by appending x0_val to the original filename
			new_filename="${og_filename}_theta_${theta_val_num}_freq_${freq_val_num}_x0_${x0_val_num}_v1.i"

			# Copy the original input file to the new filename
			cp "$og_filename$extension" "$new_filename"
			
			# Replace the theta_val value in the new input file
			sed -i "s/\(theta_deg\s*=\s*\)[0-9.eE+-]\+/\1$theta_val_num/g" "$new_filename"
			
			# Replace the freq_val value in the new input file
			sed -i "s/\(freq_val\s*=\s*\)[0-9.eE+-]\+/\1$freq_val_num/g" "$new_filename"

			# Replace the x0_val value in the new input file
			sed -i "s/\(x0_val\s*=\s*\)[0-9.eE+-]\+/\1$x0_val_num/g" "$new_filename"
			
			# Replace the mesh in the MOOSE script
			sed -i "0,/file = [^ ]*/s/file = [^ ]*/file = \"$new_mesh_name\"/" "$new_filename"
			
			# Replace the end period
			sed -i "s/\(end_period\s*=\s*\)[0-9.eE+-]\+/\1$final_period/g" "$new_filename"
			
			# Replace the input file in the Batch script
			sed -i "0,/script_name=[^ ]*/s/script_name=[^ ]*/script_name=\"$new_filename\"/" "FDTR_Batch_MOOSE.sh"
			
			freq_noexp=$(python3 -c "import math; print(int($freq_val_num*1e-6))")
			
			# Replace the job name
			sed -E -i "s/(#SBATCH --job-name=)[^[:space:]]+/\1${x0_val_num}${freq_noexp}${theta_val_num}/" "FDTR_Batch_MOOSE.sh"

			# Submit job
			sbatch FDTR_Batch_MOOSE.sh
		done
	done
done

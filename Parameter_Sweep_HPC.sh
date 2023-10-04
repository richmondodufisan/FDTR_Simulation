#!/bin/bash

#Original file name
og_filename="FDTR_input"
extension=".i"

og_mesh_script="FDTR_mesh"
og_mesh_ext=".py"


# Define the range of values you want to loop over

#x0_vals_num=("0")

#freq_vals_num=("1e6")

#theta_vals_num=("25" "35" "40" "50" "55" "65" "70" "80" "85")

x0_vals_num=("-15" "-10" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "10" "15")

freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

theta_vals_num=("0" "75")



# Loop over each x0_val value
for theta_val_num in "${theta_vals_num[@]}"; do
	for x0_val_num in "${x0_vals_num[@]}"; do
	
		# Replace the x0_val value in the mesh script
		sed -i "s/\(xcen\s*=\s*\)[0-9.eE+-]\+/\1$x0_val_num/g" "${og_mesh_script}${og_mesh_ext}"
		
		theta_rad=$(echo "scale=10; (90.0 - $theta_val_num) / 180.0 * 3.14159265359" | bc -l)
		theta_rad_og=$(echo "scale=10; ($theta_val_num) / 180.0 * 3.14159265359" | bc -l)
		tan_theta=$(python3 -c "import math; print(-1.0*math.tan($theta_rad))")
		cos_theta=$(python3 -c "import math; print(math.cos($theta_rad_og))")
		#cos_theta=1
		
		# The following are for adjusting the grain boundary refinement in the mesh script
		# These "corrections" ensure that the boundaries align and thus keep the mesh conforming
		# It is done using simple theory of the equation of a line
		xlen=40.0
		zlen=40.0
		gb_width=0.1
		
		# refine region 10x the size of the grain boundary to the left and right
		part_width=$(echo "scale=10; ($gb_width/$cos_theta)*2.5" | bc -l)
		
		xleft_up_val=$(echo "scale=10; -($part_width/2.0)" | bc -l)
		xright_up_val=$(echo "scale=10; ($part_width/2.0)" | bc -l)
		
		# Replace value(s) in the mesh script
		sed -i "s/\(x_left_up\s*=\s*\)[0-9.eE+-]\+/\1$xleft_up_val/g" "${og_mesh_script}${og_mesh_ext}"			
		sed -i "s/\(x_right_up\s*=\s*\)[0-9.eE+-]\+/\1$xright_up_val/g" "${og_mesh_script}${og_mesh_ext}"
		
		
		
		######### Getting x & z co-ordinates for LEFT side #########
		# Checking for zero angle
		is_angle_zero=$(python -c "theta_val_num = $theta_val_num; result = 1 if -1e-8 <= theta_val_num <= 1e-8 else 0; print(result)")

		if [ "$is_angle_zero" -eq 1 ]; then
			xleft_down_val=$xleft_up_val
			zleft_down_val=-$zlen
		else
			xleft_down_val=$(echo "scale=10; (1.0/$tan_theta)*(-$zlen+$tan_theta*$xleft_up_val)" | bc -l)
			zleft_down_val=-$zlen
		fi
		
		# Editing angle in mesh, see mesh .geo file for more details
		if [ "$(echo "$xleft_down_val >= $xlen" | bc -l)" -eq 1 ]; then
			xleft_down_val=$xlen
			zleft_down_val=$(echo "($tan_theta*$xlen)-($tan_theta*$xleft_up_val)" | bc -l)
		fi
		
		# Replace value(s) in the mesh script
		sed -i "s/\(x_left_down\s*=\s*\)[0-9.eE+-]\+/\1$xleft_down_val/g" "${og_mesh_script}${og_mesh_ext}"			
		sed -i "s/\(z_left_down\s*=\s*\)[0-9.eE+-]\+/\1$zleft_down_val/g" "${og_mesh_script}${og_mesh_ext}"
		
		
		
		######### Getting x & z co-ordinates for RIGHT side #########
		# Checking for zero angle
		if [ "$is_angle_zero" -eq 1 ]; then
			xright_down_val=$xright_up_val
			zright_down_val=-$zlen
		else
			xright_down_val=$(echo "scale=10; (1.0/$tan_theta)*(-$zlen+$tan_theta*$xright_up_val)" | bc -l)
			zright_down_val=-$zlen	
		fi
		
		# Editing angle in mesh, see mesh .geo file for more details
		if [ "$(echo "$xright_down_val >= $xlen" | bc -l)" -eq 1 ]; then
			xright_down_val=$xlen
			zright_down_val=$(echo "($tan_theta*$xlen)-($tan_theta*$xright_up_val)" | bc -l)
		fi
		
		# Replace value(s) in the mesh script
		sed -i "s/\(x_right_down\s*=\s*\)[0-9.eE+-]\+/\1$xright_down_val/g" "${og_mesh_script}${og_mesh_ext}"			
		sed -i "s/\(z_right_down\s*=\s*\)[0-9.eE+-]\+/\1$zright_down_val/g" "${og_mesh_script}${og_mesh_ext}"
		
		# Replace the mesh name in the mesh script
		new_mesh_name="${og_mesh_script}_theta_${theta_val_num}_x0_${x0_val_num}.msh"
		sed -i "0,/newMeshName = [^ ]*/s/newMeshName = [^ ]*/newMeshName = \"$new_mesh_name\"/" "${og_mesh_script}${og_mesh_ext}"	
		
		#echo "$new_mesh_name"
		
		# Make new 3D mesh
		python3 FDTR_mesh.py >> gmsh_output.txt &
		wait
		
		# Submit Job
		# sbatch --wait FDTR_Batch_gmsh.sh
		
		echo "Mesh Generated, x0 = ${x0_val_num}, theta = ${theta_val_num}"
	
		for freq_val_num in "${freq_vals_num[@]}"; do
			# Create a new filename by appending x0_val to the original filename
			new_filename="${og_filename}_theta_${theta_val_num}_freq_${freq_val_num}_x0_${x0_val_num}.i"

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
			
			# Replace the input file in the Batch script
			sed -i "0,/script_name=[^ ]*/s/script_name=[^ ]*/script_name=\"$new_filename\"/" "FDTR_Batch_MOOSE.sh"

			# Submit job
			sbatch FDTR_Batch_MOOSE.sh
		done
	done
done

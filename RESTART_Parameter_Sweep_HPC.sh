#!/bin/bash

#Initial input file name
init_filename="FDTR_input"

#Original file name
og_filename="FDTR_input_restart"
extension=".i"

former_sim_ver="v4"
new_sim_ver="v5"

old_start=6.0
old_end=8.0

new_start=8.0
new_end=10.0


# Define the range of values you want to loop over

#x0_vals_num=("0")

#freq_vals_num=("1e6")

#theta_vals_num=("0")

x0_vals_num=("-15" "-10" "-9" "-8" "-7" "-6" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "15")

freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

theta_vals_num=("0")


# Loop over values
for x0_val_num in "${x0_vals_num[@]}"; do
	for theta_val_num in "${theta_vals_num[@]}"; do
		for freq_val_num in "${freq_vals_num[@]}"; do
		
			# Create a new filename by appending x0_val to the original filename
			new_filename="${init_filename}_theta_${theta_val_num}_freq_${freq_val_num}_x0_${x0_val_num}_${new_sim_ver}.i"

			# Copy the original input file to the new filename
			cp "$og_filename$extension" "$new_filename"
			
			# Replace the theta_val value in the new input file
			sed -i "s/\(theta_deg\s*=\s*\)[0-9.eE+-]\+/\1$theta_val_num/g" "$new_filename"
			
			# Replace the freq_val value in the new input file
			sed -i "s/\(freq_val\s*=\s*\)[0-9.eE+-]\+/\1$freq_val_num/g" "$new_filename"

			# Replace the x0_val value in the new input file
			sed -i "s/\(x0_val\s*=\s*\)[0-9.eE+-]\+/\1$x0_val_num/g" "$new_filename"
			
			# Replace the mesh in the MOOSE script
			former_sim_output="${init_filename}_theta_${theta_val_num}_freq_${freq_val_num}_x0_${x0_val_num}_${former_sim_ver}_out.e"
			sed -i "0,/file = [^ ]*/s/file = [^ ]*/file = \"$former_sim_output\"/" "$new_filename"
			
			
			############# Replacing end and start periods #############
			
			sed -i "s/\(prev_start\s*=\s*\)[0-9.eE+-]\+/\1$old_start/g" "$new_filename"
			sed -i "s/\(prev_end\s*=\s*\)[0-9.eE+-]\+/\1$old_end/g" "$new_filename"
			sed -i "s/\(start_period\s*=\s*\)[0-9.eE+-]\+/\1$new_start/g" "$new_filename"
			sed -i "s/\(end_period\s*=\s*\)[0-9.eE+-]\+/\1$new_end/g" "$new_filename"
			
			############# END Replacing end and start periods #############
			
			
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
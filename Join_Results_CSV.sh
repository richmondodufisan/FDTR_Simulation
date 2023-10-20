#!/bin/bash

versions_list=("v1" "v2" "v3" "v4" "v5")

theta_angle=0
n_periods=2
stop_line_number=$(python3 -c "import math; print((396*$n_periods)+1)")

echo $stop_line_number

# Output file
output_file="../MOOSE_theta_${theta_angle}_T10_new.csv"

# Create header for the output file
echo "freq, x0, time, delta_temp" > "$output_file"

# Get a list of files that fit the pattern using ls -d
# file_list=$(ls -d fdtr_input_freq_*_x0_*.csv)

x0_vals_num=("-15" "-10" "-9" "-8" "-7" "-6" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "15")
freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

#x0_vals_num=("0")
#freq_vals_num=("1e6")




for x0 in "${x0_vals_num[@]}"; do
	for freq in "${freq_vals_num[@]}"; do
		for ver in "${versions_list[@]}"; do
			input_file="FDTR_input_theta_${theta_angle}_freq_${freq}_x0_${x0}_${ver}_out.csv"
			
			# Concatenate data to the output file using printf in awk, stopping at the specified line
			awk -v freq="$freq" -v x0="$x0" -v stop_line="$stop_line_number" -F, 'NR>2{
				if (NR <= stop_line) {
					printf "%s, %s, %.20f, %.20f\n", x0, freq / 1e6, $1 * 1e6, $2
				}
			}' "$input_file" >> "$output_file"
		done
	done
done


echo "Concatenation complete. Output file: $output_file"

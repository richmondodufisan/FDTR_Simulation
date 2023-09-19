#!/bin/bash

# Output file
output_file="MOOSE_theta_75_4periods.csv"

# Create header for the output file
echo "freq, x0, time, delta_temp" > "$output_file"

# Get a list of files that fit the pattern using ls -d
# file_list=$(ls -d fdtr_input_freq_*_x0_*.csv)

x0_vals_num=("-15" "-10" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "10" "15")
freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

#x0_vals_num=("-15" "-10" "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "10" "15")
#freq_vals_num=("1e6" "2e6" "4e6" "6e6" "10e6")

for x0 in "${x0_vals_num[@]}"; do
	for freq in "${freq_vals_num[@]}"; do
		input_file="FDTR_input_theta_0_freq_${freq}_x0_${x0}_out.csv"
		
		# Concatenate data to the output file using printf in awk
		awk -v freq="$freq" -v x0="$x0" -F, 'NR>1{printf "%s, %s, %.20f, %.20f\n", x0 , freq / 1e6, $1 * 1e6, $2}' "$input_file" >> "$output_file"
	done
done


echo "Concatenation complete. Output file: $output_file"

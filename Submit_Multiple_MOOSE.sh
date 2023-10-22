#!/bin/bash

# Function to check if there are any jobs in the Slurm queue
function check_squeue() {
    squeue_output=$(squeue -u vtw1026 -h)  # Replace with your actual username
    if [ -z "$squeue_output" ]; then
        return 0  # No jobs in the queue
    else
        return 1  # Jobs are in the queue
    fi
}


# Set the maximum number of times to submit the batch job
n_iterations=2

# Set the number of periods each job/sweep should solve for
n_periods_per_job=1.0

# Initial timestep
start_val=0.0

# Replace the end period in the initial parameter sweep
sed -i "s/\(final_period\s*=\s*\)[0-9.eE+-]\+/\1$n_periods_per_job/g" "Parameter_Sweep_HPC.sh"

# Submit the initial parameter sweep
./Parameter_Sweep_HPC.sh

submission_count=1
o_start=$start_val

# Main loop
while [ $submission_count -lt $n_iterations ]; do
    check_squeue
    if [ $? -eq 0 ]; then
		echo "No jobs in the queue. Submitting batch job script..."

		o_ver=$(echo "$submission_count" | bc -l)
		n_ver=$(echo "$submission_count + 1" | bc -l)

		# Use -i to edit the file in place and double quotes to interpolate variables
		sed -i -E "s/former_sim_ver=[^[:space:]]+/former_sim_ver=v${o_ver}/" "RESTART_Parameter_Sweep_HPC.sh"
		sed -i -E "s/new_sim_ver=[^[:space:]]+/new_sim_ver=v${n_ver}/" "RESTART_Parameter_Sweep_HPC.sh"

		o_stop=$(echo "$o_start + $n_periods_per_job" | bc -l)
		n_stop=$(echo "$o_stop + $n_periods_per_job" | bc -l)

		# Use -i to edit the file in place and double quotes to interpolate variables
		sed -i "s/\(old_start\s*=\s*\)[0-9.eE+-]\+/\1$o_start/g" "RESTART_Parameter_Sweep_HPC.sh"
		sed -i "s/\(old_end\s*=\s*\)[0-9.eE+-]\+/\1$o_stop/g" "RESTART_Parameter_Sweep_HPC.sh"
		sed -i "s/\(new_start\s*=\s*\)[0-9.eE+-]\+/\1$o_stop/g" "RESTART_Parameter_Sweep_HPC.sh"
		sed -i "s/\(new_end\s*=\s*\)[0-9.eE+-]\+/\1$n_stop/g" "RESTART_Parameter_Sweep_HPC.sh"

		./RESTART_Parameter_Sweep_HPC.sh
		submission_count=$((submission_count + 1))
		o_start=$o_stop
    else
        echo "Jobs are in the queue. Currently solving iteration no ${submission_count}. Waiting..."
    fi

    # Sleep for a while before checking again (e.g., 5 minutes)
    sleep 300
done

#!/bin/bash

start_job_id=1909531
end_job_id=1909648
user="vtw1026"

for job_id in $(squeue -u "$user" -o "%A" | awk '$1 >= start && $1 <= end' start="$start_job_id" end="$end_job_id"); do
    scancel "$job_id"
done
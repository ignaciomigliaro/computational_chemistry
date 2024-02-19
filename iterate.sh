#!/bin/bash

for i in {1..20}
do
    # Modify the input file
    awk -v num="$i" '/#PBS -N split/ {sub(/[0-9]+/, num)} 1'  qe_job_script.sh > job_script_tmp.sh

    # Change the input directory
    sed -i "s|input_dir=\"/home/im0225/NbOC/all_inputs/split[0-9]*\"|input_dir=\"/home/im0225/NbOC/all_inputs/split$i\"|" job_script_tmp.sh

    # Submit the job
    qsub job_script_tmp.sh
    # Remove temporary script
    rm job_script_tmp.sh
done

#!/bin/bash

# Function to run vasp command in each subdirectory
run_vasp() {
    for dir in */; do
        # Check if OUTCAR file exists and if 'Voluntary' pattern exists in the OUTCAR file
        if [[ -f "${dir}OUTCAR" && $(grep -c 'Voluntary' "${dir}OUTCAR") -gt 0 ]]; then
            echo "Skipping directory $dir because 'Voluntary' pattern found in OUTCAR."
            continue
        fi

        cd "$dir" || continue  # Move into the directory
        echo "Running vasp in directory: $dir"
        vasp -b std -p short.36 -c 36 -m 16gb
        sleep 20
        cd ..  # Move back to the parent directory

        # Check job status
        job_status=$(squeue -u im0225 -p share.36 | awk -v d="$dir" 'NR>1 && $9 == d {print $5}')

        # If there are any jobs in the "Running" state (R), continue to the next directory
        while [[ "$job_status" == *"R"* ]]; do
            echo "Jobs are still running in $dir. Waiting..."
            sleep 10  # Check job status every 10 seconds
            job_status=$(squeue -u im0225 -p share.36 | awk -v d="$dir" 'NR>1 && $9 == d {print $5}')
        done

        # If there are any jobs in the "Pending" state (PD), sleep for 60 seconds
        if [[ "$job_status" == *"PD"* ]]; then
            echo "There are pending jobs in $dir. Sleeping..."
            sleep 60
        fi
    done
}

# Run vasp in each subdirectory and check job status
run_vasp

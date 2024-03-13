#!/bin/bash

# Function to check if there are pending jobs in the queue
check_pending_jobs() {
    pending_jobs=$(squeue -u $USER -p short.36 | awk '$5 == "PD" {print}' | wc -l)
    echo "$pending_jobs"
}

    for dir in */; do
        # Check if OUTCAR file exists and if 'Voluntary' pattern exists in the OUTCAR file
        if [[ -f "${dir}OUTCAR" && $(grep -c 'Voluntary' "${dir}OUTCAR") -gt 0 ]]; then
            echo "Skipping directory $dir because 'Voluntary' pattern found in OUTCAR."
            continue
        fi
        cd "$dir" || continue  # Move into the directory
        echo "Running vasp in directory: $dir"
        vasp -b std -p short.36 -c 36 -m 50gb -s network
        cd ..  # Move back to the parent directory
        pending_jobs=$(check_pending_jobs)
        echo "There are $pending_jobs in Queue"
        while [[ $(check_pending_jobs) -gt 0 ]]; do
                echo "There are pending jobs in the queue. Sleeping..."
                sleep 300
    done
done

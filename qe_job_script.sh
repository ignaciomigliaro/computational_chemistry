#!/bin/bash
#!/bin/bash
#SBATCH -o slurm-%j.out            # Output file
#SBATCH -e slurm-%j.err           # Error file
#SBATCH --ntasks-per-node=30       # Number of tasks (or cores)
#SBATCH --cpus-per-task=1          # Number of CPU cores per task
#SBATCH --nodes=1                  ## Number of nodes to be used
#SBATCH --mem=100gb                   ##Memory per node to be used.
#SBATCH -p share.36      # Partition or queue name

input_dir="/home/im0225/NbOC/all_inputs/split2"

#Check if Directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' not found."
    exit 1
fi

# Define the list of input files for Quantum ESPRESSO calculations
input_files=("$input_dir"/*.in)

# Check if there are any input files in the directory
if [ ${#input_files[@]} -eq 0 ]; then
    echo "Error: No input files (*.in) found in directory '$input_dir'."
    exit 1
fi

echo "Running Quantum ESPRESSO for files in directory: $input_dir"

module purge
module load QE/7.1/imkl_gcc12.2_ompi4.1.4

# Print the input files for this batch
echo "Running Quantum ESPRESSO for files: $BATCH_FILES"

# Loop through the input files and run Quantum ESPRESSO for each task
for input_file in "${input_files[@]}"
do
    echo "Processing file: $input_file"
    mpirun -np 30 pw.x -input $input_file > "${input_file%.in}.out"
done

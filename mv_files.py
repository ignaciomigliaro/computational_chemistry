import os
import shutil

# Create 20 directories if they don't exist
for i in range(1, 21):
    directory_name = 'split%d' % i
    if not os.path.exists(directory_name):
        os.makedirs(directory_name)

# List all the files in the current directory
files = [f for f in os.listdir('.') if f.endswith("_pwscf.in")]

# Calculate the number of files per directory
files_per_directory = len(files) // 20

# Distribute files to the directories
for i in range(20):
    start_index = i * files_per_directory
    end_index = (i + 1) * files_per_directory if i < 19 else None
    destination_directory = 'split%d' % (i + 1)

    for file in files[start_index:end_index]:
        source_path = os.path.join(os.getcwd(), file)
        destination_path = os.path.join(os.getcwd(), destination_directory, file)

        # Check if the destination directory exists, create it if not
        if not os.path.exists(destination_directory):
            os.makedirs(destination_directory)

        shutil.move(source_path, destination_path)

print("Files successfully distributed into 20 directories.")




import numpy as np
import os
import sys

# Define job name.
script_name = "synopsis_scattering.m"
script_path = os.path.join("..", script_name)
call_str = "run(\'" + script_name + "\');"


# Loop over synopsis channels.
n_channels = 12
for channel_id in range(1, 1+n_channels):

    script_path_with_args = "".join([
        "matlab -nosplash -nodesktop -nodisplay -r ",
        "\"",
        "channel_id = " + str(channel_id).zfill(2) + "; ",
        call_str,
        "\""])

    # Define slurm name.
    job_name = "synopsis_scattering_ch-" + str(channel_id).zfill(2)
    file_path = job_name + ".sbatch"
    slurm_path = job_name + "_%j.out"

    # Write call to python in SBATCH file.
    with open(file_path, "w") as f:
        f.write("#!/bin/bash\n")
        f.write("\n")
        f.write("#BATCH --job-name=" + job_name + "\n")
        f.write("#SBATCH --nodes=1\n")
        f.write("#SBATCH --tasks-per-node=1\n")
        f.write("#SBATCH --cpus-per-task=1\n")
        f.write("#SBATCH --time=01:00:00\n")
        f.write("#SBATCH --mem=8GB\n")
        f.write("#SBATCH --output=" + slurm_path + "\n")
        f.write("\n")
        f.write("module purge\n")
        f.write("module load matlab/2017a\n")
        f.write("\n")
        f.write(script_path_with_args)


# Create shell file to launch sbatch files.
shell_path = "synopsis_scattering.sh"
with open(shell_path, "w") as f:
    # Print header
    f.write("# This shell script executes all Slurm jobs " +\
        "for scattering transforms.\n")
    f.write("\n")

    for channel_id in range(1, 1+n_channels):
        job_name = "synopsis_scattering_ch-" + str(channel_id).zfill(2)
        f.write("sbatch " + job_name + ".sbatch\n")

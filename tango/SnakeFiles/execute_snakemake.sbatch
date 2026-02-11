#!/usr/bin/env bash
#SBATCH --job-name=snakemake_testing
#SBATCH --nodes=1
#SBATCH --ntasks=4                 # use 4 cores, dont specify --cores all in the actual snakemake call... or it will default to this value...
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --time=5:30:00
#SBATCH --output=snakemake_testing-%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail@colostate.edu

set -euo pipefail

# Run the pipeline
snakemake --workflow-profile ClusterProfiles/slurm -p

# Say we finished
echo -e "\n\nSnakemake Testing Master Scheduling Job Complete"

#!/usr/bin/env bash
#SBATCH --job-name=transrate_submodule
#SBATCH --nodes=1
#SBATCH --ntasks=16                 # use 4 cores, dont specify --cores all in the actual snakemake call... or it will default to this value...
#SBATCH --mem=96G
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --time=1:30:00
#SBATCH --output=transrate_submodule-%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail@colostate.edu

# SNAP in transrate uses lots of ram, request enough for your assembly/reads...

set -euo pipefail

# Run the TransrateSubModule.py script
python TransrateSubModule.py -i /scratch/alpine/youremail@colostate.edu/Output/stringtie/merged/stringtie_merged.fa -r /scratch/alpine/youremail.edu/Output/fastp  -o /scratch/alpine/youremail@colostate.edu/Output/transrate -t 16

# Say we finished
echo -e "\n\nTransrate Job Complete!"

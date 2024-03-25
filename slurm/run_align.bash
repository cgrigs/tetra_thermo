#!/bin/bash

#SBATCH -N 1            # number of nodes
#SBATCH -c 1            # number of cores
#SBATCH -t 7-00:00:00   # time in d-hh:mm:ss
#SBATCH --mem=24G       # memory limit
#SBATCH -p general          # partition
#SBATCH -q public       # QOS
#SBATCH -o logs/slurm.%A_%a.out # file to save job's STDOUT (%%A_%a = JobId ARRAY INDEX)
#SBATCH -e logs/slurm.%A_%a.out # file to save job's STDERR (%A_%a = JobId)
#SBATCH --mail-user=cgrigsb2@asu.edu
#SBATCH --mail-type=FAIL # Send an e-mail when a job fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment
#SBATCH --array=1-570 #Change depending on the number of lines in the manifest file

cd /scratch/cgrigsb2/tet/tetra_thermo
manifest=/scratch/cgrigsb2/tet/tetra_thermo/manifest.txt


module load mamba/latest
source activate TetMA
module add r-4.3.0-aocc-3.1.0


stem=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$manifest")

echo "SLURM_ARRAY_TASK_ID=$SLURM_ARRAY_TASK_ID"
echo "Now on STEM: $stem"

#1
make -f align.mk "data/bam_mac_aligned/bam_aln/${stem}.bam"
#2
make -f align.mk "data/bam_mac_aligned/bam_fixmate/${stem}.bam"
#3
make -f align.mk "data/bam_mac_aligned/bam_merged/${stem}.bam"
#4
make -f align.mk "data/bam_mac_aligned/bam_sort/${stem}.bam"
#5
make -f align.mk "data/bam_mac_aligned/bam_dedup/${stem}.bam"

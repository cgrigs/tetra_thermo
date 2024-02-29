#!/bin/bash

#SBATCH -N 1            # number of nodes
#SBATCH -c 1            # number of cores
#SBATCH -t 4:00:00   # time in d-hh:mm:ss
#SBATCH --mem=64G       # memory limit
#SBATCH -p htc          # partition
#SBATCH -q public       # QOS
#SBATCH -o logs/slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e logs/slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-user=cgrigsb2@asu.edu
#SBATCH --mail-type=FAIL # Send an e-mail when a job fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module load mamba/latest
source activate TetMA
module purge
module add r-4.3.0-aocc-3.1.0

#PICARD="/home/cgrigsb2/.conda/envs/TetMA/share/picard-3.0.0-0/picard.jar"
SAMTOOLS="/home/cgrigsb2/.conda/envs/TetMA/bin/samtools"
BWA="/home/cgrigsb2/.conda/envs/TetMA/bin/bwa"


stem=$1

make -f align.mk "data/bam_mac_aligned/bam_dedup/%.bam"

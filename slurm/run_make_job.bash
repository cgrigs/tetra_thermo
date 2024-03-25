#!/bin/bash

#SBATCH -N 1            # number of nodes
#SBATCH -c 16           # number of cores
#SBATCH --mem=64G       # memory limit
#SBATCH -t 6-00:00:00   # time in d-hh:mm:ss
#SBATCH -p general      # partition
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

#cd /scratch/cgrigsb2/tet/tetra_thermo

make -k -j ${SLURM_CPUS_PER_TASK} $1

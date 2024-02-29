#!/bin/bash

FASTQ_DIR="/scratch/cgrigsb2/tet/TetMA/Tthermophila_fastqs"

'''
# fifth column of metadata.tsv contains sample 
#SAMPLES=$(cut -f5 metadata.tsv | tail -n +2 | sort | uniq)

for SAMPLE in $SAMPLES; do
    # Construct a meaningful job name, e.g., based on the sample name
    JOB_NAME="process_${SAMPLE}"
    
    # Submit the job
    sbatch --job-name=$JOB_NAME run_single_sample.sh $SAMPLE
done
'''


# Iterate over FASTQ files
for FASTQ_FILE in ${FASTQ_DIR}/*_R1_001.fastq.gz; do
    # Extract the sample name/identifier from the FASTQ filename
    SAMPLE=$(basename ${FASTQ_FILE} "_R1_001.fastq.gz")
    
    # Construct a meaningful job name, e.g., based on the sample name
    JOB_NAME="process_${SAMPLE}"
    
    # Submit the job
    sbatch --job-name=$JOB_NAME run_single_sample.sh $SAMPLE
done
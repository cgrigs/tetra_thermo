#!/bin/bash

FASTQ_DIR="/scratch/cgrigsb2/tet/TetMA/Tthermophila_fastqs"

'''
# fifth column of metadata.tsv contains sample 
#SAMPLES=$(cut -f5 metadata.tsv | tail -n +2 | sort | uniq)

for SAMPLE in $SAMPLES; do
    JOB_NAME="process_${SAMPLE}"
    
    sbatch --job-name=$JOB_NAME run_single_sample.sh $SAMPLE
done
'''


# Iterate over FASTQ files
for FASTQ_FILE in ${FASTQ_DIR}/*_R1_001.fastq.gz; do
    SAMPLE=$(basename ${FASTQ_FILE} "_R1_001.fastq.gz")
    JOB_NAME="process_${SAMPLE}"
    
    sbatch --job-name=$JOB_NAME run_single_sample.sh $SAMPLE
done

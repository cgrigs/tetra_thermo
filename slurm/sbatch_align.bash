#!/bin/bash
rm run_alighn.manifest
find /scratch/cgrigsb2/tet/TetMA/Tthermophila_fastqs/ -type f -name '*.fastq.gz' -exec \
    sh -c 'STEM=$(basename {} .fastq.gz); echo -e "$STEM" >> /scratch/cgrigsb2/tet/tetra_thermo/slurm/run_alighn.manifest' \;

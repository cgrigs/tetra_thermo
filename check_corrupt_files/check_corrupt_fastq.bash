#!/bin/bash

DIRECTORY="/scratch/cgrigsb2/TetMA/Tthermophila_fastqs"

OUTPUT_FILE="corrupt_files_list.txt"

> "$OUTPUT_FILE"

for file in "$DIRECTORY"/*.fastq.gz; do
    # Test the gzip file for integrity
    if ! gzip -t "$file" 2>/dev/null; then
        # If gzip returns a non-zero status, the file is corrupt
        echo "$(basename "$file")" >> "$OUTPUT_FILE"
    fi
done

#Info/test if corrupt files were found
if [ -s "$OUTPUT_FILE" ]; then
    echo "Corrupt files list has been created in $OUTPUT_FILE."
else
    echo "No corrupt files found."
fi

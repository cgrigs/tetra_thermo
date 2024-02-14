#!/bin/bash

DIRECTORY="/scratch/cgrigsb2/TetMA/Tthermophila_fastqs/"
OUTPUT_FILE="file_names_list.txt"

# Empty or create the file to store file names
> "$OUTPUT_FILE"

for file in "$DIRECTORY"/*; do
    basename "$file" >> "$OUTPUT_FILE"
done

echo "File names have been written to $OUTPUT_FILE."
